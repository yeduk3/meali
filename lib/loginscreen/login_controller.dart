import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:meali/mainscreen/data_loader.dart';
import 'package:meali/common/user_data.dart';

import 'package:http/http.dart' as http;

class LoginController {
  /// [Singleton Pattern]
  /// Create empty private constructor
  LoginController._privateConstructor();

  /// Instance of singleton
  static final LoginController _instance = LoginController._privateConstructor();

  // Constructor but, for singleton
  factory LoginController() {
    return _instance;
  }

  /// Login Status
  bool _isLoggedIn = false;

  /// ReadOnly, Login Status
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> loginWithKakao(BuildContext context) async {
    bool isLoginSuccess = false;

    isLoginSuccess = await _kakaoLoginMethod();

    /// [Status]
    await _updateLogInStatus();

    return isLoginSuccess;
  }

  Future<bool> haskakaoLoginToken() async {
    bool hasToken = false;

    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        if (kDebugMode) print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

        /// [Status]
        await _updateLogInStatus();

        hasToken = true;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          if (kDebugMode) print('토큰 만료 $error');
        } else {
          if (kDebugMode) print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      if (kDebugMode) print('발급된 토큰 없음');
    }
    return hasToken;
  }

  Future<void> _userRegistration(int id, String username, String thumbnailUrl) async {
    Uri uri = Uri.http(
      dotenv.env['SERVER_HOST']!,
      'registration',
    );

    var body = jsonEncode({
      "id": "$id",
      "username": username,
      "thumbnailUrl": thumbnailUrl,
    });
    var post = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (post.statusCode == 200)
      print("Success");
    else
      print("Fail: ${post.body}");
  }

  Future<bool> _kakaoLoginMethod() async {
    bool isLoginSuccess = false;
    if (await isKakaoTalkInstalled()) {
      /// [KakaoTalk Installed]
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();

        if (kDebugMode) print('카카오톡으로 로그인 성공 ${token.accessToken}');

        isLoginSuccess = true;
      } catch (error) {
        throw Exception('KakaoTalk Login Failed $error');
      }
    } else {
      /// [KakaoTalk Not Installed]
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        if (kDebugMode) print('카카오계정으로 로그인 성공 ${token.accessToken}');

        isLoginSuccess = true;
      } catch (error) {
        throw Exception('KakaoAccount Login Failed $error');
      }
    }
    return isLoginSuccess;
  }

  Future<void> _updateLogInStatus() async {
    _isLoggedIn = true;

    // Get Profile
    String username = '', thumbnailUrl = '';
    try {
      TalkProfile profile = await TalkApi.instance.profile();
      if (kDebugMode) {
        print('카카오톡 프로필 받기 성공'
            '\n닉네임: ${profile.nickname}'
            '\n프로필사진: ${profile.thumbnailUrl}');
      }
      username = profile.nickname!;
      thumbnailUrl = profile.thumbnailUrl!;
    } catch (error) {
      throw Exception('Get Kakao Profile Failed $error');
    }
    User me = await UserApi.instance.me();

    // ignore: unused_local_variable
    DataLoader dataLoader = DataLoader.from(
      UserData(
        userId: me.id,
        username: username,
        thumbnailUrl: thumbnailUrl,
      ),
    );

    await _userRegistration(me.id, username, thumbnailUrl);
  }
}
