import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meali/common/group_content.dart';
import 'package:meali/common/group_info.dart';
import 'package:meali/common/group_info_extended.dart';
import 'package:meali/common/simple_uri_builder.dart';
import 'package:meali/common/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DataLoader {
  /// [Singleton Pattern with Configs]

  static DataLoader? _instance;

  factory DataLoader.from(UserData userdata) {
    return _instance = DataLoader._internal(userdata);
  }

  factory DataLoader() {
    if (_instance == null) {
      throw Exception("Instance is null. Call .from constructor first");
    }
    return _instance!;
  }

  DataLoader._internal(this._myUserData);

  /// User data who logged in
  final UserData? _myUserData;

  UserData? getMyUserData() {
    return _myUserData;
  }

  Future<List<UserData>> getSameGroupUserData(int groupID) async {
    // if (kDebugMode) print("Get Same Group User Data");

    Uri uri = simpleUriBuilder(
      dotenv.env['SAMEGROUP_USERDATA']!,
      {
        'userID': '${_myUserData?.userId}',
        'groupID': '$groupID',
      },
    );

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as List<dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["sameGroupUsers"]}");
      // List<dynamic> userList = resjson["sameGroupUsers"];
      List<UserData> userDataList = resjson
          .map((e) => UserData(
                userId: e["userID"] as int,
                username: e["username"] as String,
                thumbnailUrl: e["thumbnailUrl"] as String,
              ))
          .toList();
      // if (kDebugMode) print(userDataList);
      return userDataList;
    } else {
      if (kDebugMode) print("Connection error with status code: ${response.statusCode}");
      throw Exception("Connection error with status code: ${response.statusCode}");
    }
  }

  Future<List<GroupContent>> getGroupContent(int groupID) async {
    // if (kDebugMode) print("Get Group Data");
    Uri uri = simpleUriBuilder(
      dotenv.env['SAMEGROUP_CONTENT']!,
      {
        'userID': '${_myUserData?.userId}',
        'groupID': '$groupID',
      },
    );

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as List<dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["groupContents"]}");
      // List<dynamic> userList = resjson["groupContents"];
      List<GroupContent> userDataList = resjson
          .map((e) => GroupContent(
                groupID: e["groupID"] as int,
                content: e["content"] as String,
                contentID: e["contentID"] as int,
              ))
          .toList();
      if (kDebugMode) print(userDataList);
      return userDataList;
    } else {
      if (kDebugMode) print("Connection error with status code: ${response.statusCode}");
      throw Exception("Connection error with status code: ${response.statusCode}");
    }
  }

  Future<List<GroupInfoExtended>> getGroupList() async {
    // if (kDebugMode) print("Get Group Name List for App Bar");
    Uri uri = simpleUriBuilder(
      dotenv.env['GROUPDATA']!,
      {
        'userID': '${_myUserData?.userId}',
      },
    );

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as List<dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["groupnamelist"]}");
      // if (kDebugMode) print(resjson["groupnamelist"].runtimeType);
      // List<dynamic> list = resjson["groupInfoList"];
      List<GroupInfoExtended> groupList = resjson
          .map((e) => GroupInfoExtended(
                groupName: e["groupName"] as String,
                groupID: e["groupID"] as int,
                userCount: e["userCount"] as int,
              ))
          .toList();
      // if (kDebugMode) print(groupList);
      return groupList;
    } else {
      if (kDebugMode) print("Connection error with status code: ${response.statusCode}");
      throw Exception("Connection error with status code: ${response.statusCode}");
    }
  }

  Future<void> postContent(int groupID, String content) async {
    Uri uri = simpleUriBuilder(dotenv.env['UPLOAD_CONTENT']!);

    var body = convert.jsonEncode({
      'groupID': "$groupID",
      'content': content,
    });

    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (kDebugMode) {
      print("응답 결과: ${response.statusCode}");
      print("응답 결과: ${response.body}");
    }
  }

  Future<int> deleteContent(int contentId) async {
    Uri uri = simpleUriBuilder(dotenv.env['DELETE_CONTENT']!, {"contentId": "$contentId"});

    var response = await http.delete(uri);

    if (kDebugMode) print("콘텐츠 제거 요청 결과: ${response.statusCode} ${response.body}");

    return response.statusCode;
  }

  Future<int> createAndJoinNewGroupByName(String groupName) async {
    int groupId = await createNewGroupByName(groupName);
    if (groupId < 0) {
      if (kDebugMode) print("그룹 생성 실패");
      return -1;
    }
    var responseStatusCode = await joinGroup(groupId);
    if (responseStatusCode == 200) {
      if (kDebugMode) print("그룹 가입 성공");
      return groupId;
    } else {
      if (kDebugMode) print("그룹 가입 실패");
      return -2;
    }
  }

  Future<int> createNewGroupByName(String groupName) async {
    Uri uri = simpleUriBuilder(dotenv.env["CREATE_GROUP"]!);

    http.Response response = await http.post(uri, body: groupName);

    if (kDebugMode) print("그룹 생성 요청 응답: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return resjson["id"] ?? -1;
    } else {
      return -response.statusCode;
    }
  }

  Future<int> joinGroup(int groupId) async {
    Uri uri = simpleUriBuilder(dotenv.env["JOIN_GROUP"]!);

    var body = convert.jsonEncode({"userId": "${getMyUserData()?.userId}", "groupId": "$groupId"});

    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (kDebugMode) print("그룹 들어가기 요청 응답: ${response.statusCode} ${response.body}");

    return response.statusCode;
  }

  Future<int> deleteGroupById(int groupId) async {
    Uri uri = simpleUriBuilder(dotenv.env["DELETE_GROUP"]!, {"groupId": "$groupId"});

    http.Response response = await http.delete(uri);

    if (kDebugMode) print("그룹 삭제 요청 결과: ${response.statusCode} ${response.body}");

    return response.statusCode;
  }

  Future<GroupInfo> findGroupById(int groupId) async {
    Uri uri = simpleUriBuilder(dotenv.env["FIND_GROUP"]!, {"groupId": "$groupId"});

    var response = await http.get(uri);

    if (kDebugMode) print("그룹 탐색 결과: ${response.statusCode} ${response.body}");

    var json = convert.jsonDecode(response.body);
    var gId = json["id"];
    var gn = json["groupName"];
    GroupInfo ret = GroupInfo(groupID: gId, groupName: gn);

    return ret;
  }

  Future<int> leaveGroupBy(int groupId) async {
    Uri uri = simpleUriBuilder(
      dotenv.env["LEAVE_GROUP"]!,
      {"userId": "${_myUserData?.userId}", "groupId": "$groupId"},
    );

    var response = await http.delete(uri);

    if (kDebugMode) print("그룹 나가기 결과: ${response.statusCode} ${response.body}");

    return int.parse(response.body);
  }
}
