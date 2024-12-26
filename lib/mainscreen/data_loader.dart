import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meali/common/group_content.dart';
import 'package:meali/common/group_info.dart';
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

    Uri url = Uri.http(
      dotenv.env['SERVER_HOST']!,
      '/samegroupusers',
      {
        'userID': '${_myUserData?.userId}',
        'groupID': '$groupID',
      },
    );

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["sameGroupUsers"]}");
      List<dynamic> userList = resjson["sameGroupUsers"];
      List<UserData> userDataList = userList.map((e) {
        return UserData(
          userId: e["userID"] as int,
          username: e["username"] as String,
          thumbnailUrl: e["thumbnailUrl"] as String,
        );
      }).toList();
      // if (kDebugMode) print(userDataList);
      return userDataList;
    } else {
      if (kDebugMode) print("Connection error with status code: ${response.statusCode}");
      throw Exception("Connection error with status code: ${response.statusCode}");
    }
  }

  Future<List<GroupContent>> getGroupContent(int groupID) async {
    // if (kDebugMode) print("Get Group Data");
    Uri url = Uri.http(
      dotenv.env['SERVER_HOST']!,
      '/samegroupcontent',
      {
        'userID': '${_myUserData?.userId}',
        'groupID': '$groupID',
      },
    );

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["groupContents"]}");
      List<dynamic> userList = resjson["groupContents"];
      List<GroupContent> userDataList = userList
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

  Future<List<GroupInfo>> getGroupList() async {
    // if (kDebugMode) print("Get Group Name List for App Bar");
    Uri url = Uri.http(
      dotenv.env['SERVER_HOST']!,
      '/groupinfolist',
      {
        'userID': '${_myUserData?.userId}',
      },
    );

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      // if (kDebugMode) print("Mapping start: ${resjson["groupnamelist"]}");
      // if (kDebugMode) print(resjson["groupnamelist"].runtimeType);
      List<dynamic> list = resjson["groupInfoList"];
      List<GroupInfo> groupList = list
          .map((e) => GroupInfo(
                groupName: e["groupName"] as String,
                groupID: e["groupID"] as int,
              ))
          .toList();
      // if (kDebugMode) print(groupList);
      return groupList;
    } else {
      if (kDebugMode) print("Connection error with status code: ${response.statusCode}");
      throw Exception("Connection error with status code: ${response.statusCode}");
    }
  }

  Future<void> postData(int groupID, String content) async {
    Uri uri = Uri.http(
      dotenv.env['SERVER_HOST']!,
      'uploadcontent',
    );

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

  Future<bool> createAndJoinNewGroupByName(String groupName) async {
    int groupId = await createNewGroupByName(groupName);
    if (groupId < 0) {
      if (kDebugMode) print("그룹 생성 실패");
      return false; // 가입 실패.
    }
    var responseStatusCode = await joinGroup(groupId);
    if (responseStatusCode == 200) {
      if (kDebugMode) print("그룹 가입 성공");
      return true;
    } else {
      if (kDebugMode) print("그룹 가입 실패");
      return false;
    }
  }

  Future<int> createNewGroupByName(String groupName) async {
    Uri uri = simpleUriBuilder('creategroup');

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
    Uri uri = simpleUriBuilder('joingroup');

    var body = convert.jsonEncode({"userId": "${getMyUserData()?.userId}", "groupId": "$groupId"});

    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (kDebugMode) print("그룹 들어가기 요청 응답: ${response.statusCode} ${response.body}");

    return response.statusCode;
  }

  Uri simpleUriBuilder(String path) {
    return Uri.http(
      dotenv.env['SERVER_HOST']!,
      path,
    );
  }
}
