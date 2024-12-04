import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meali/common/group_data.dart';
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

  DataLoader._internal(this.myUserData);

  /// User data who logged in
  final UserData myUserData;

  Future<List<UserData>> getSameGroupUserData() async {
    print("Get Same Group User Data");
    Uri url = Uri.http(
      dotenv.env['SERVER_HOST']!,
      '/samegroupusers',
      {
        'userID': '${myUserData.userId}',
        'groupID': '2',
      },
    );

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      print("Mapping start: ${resjson["sameGroupUsers"]}");
      List<dynamic> userList = resjson["sameGroupUsers"];
      List<UserData> userDataList = userList.map((e) {
        return UserData(
          userId: e["userID"] as int,
          username: e["username"] as String,
          thumbnailUrl: e["thumbnailUrl"] as String,
        );
      }).toList();
      print(userDataList);
      return userDataList;
    } else {
      print("Connection error with status code: ${response.statusCode}");
      throw Exception(
          "Connection error with status code: ${response.statusCode}");
    }
  }

  Future<List<GroupData>> getGroupContent() async {
    print("Get Group Data");
    Uri url = Uri.http(
      dotenv.env['SERVER_HOST']!,
      '/samegroupdata',
      {
        'userID': '${myUserData.userId}',
        'groupID': '1',
      },
    );

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var resjson = convert.jsonDecode(response.body) as Map<String, dynamic>;

      print("Mapping start: ${resjson["groupData"]}");
      List<dynamic> userList = resjson["groupData"];
      List<GroupData> userDataList = userList
          .map((e) => GroupData(
                groupID: e["groupID"] as int,
                content: e["content"] as String,
                contentID: e["contentID"] as int,
              ))
          .toList();
      print(userDataList);
      return userDataList;
    } else {
      print("Connection error with status code: ${response.statusCode}");
      throw Exception(
          "Connection error with status code: ${response.statusCode}");
    }
  }
}
