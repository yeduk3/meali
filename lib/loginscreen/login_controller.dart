import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:meali/mainscreen/main_page.dart';

class LoginController {
  /// [Singleton Pattern]
  /// Create empty private constructor
  LoginController._privateConstructor();

  /// Instance of singleton
  static final LoginController _instance =
      LoginController._privateConstructor();

  // Constructor but, for singleton
  factory LoginController() {
    return _instance;
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void loginWithKakao(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // ignore: avoid_print
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        // ignore: avoid_print
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        // ignore: avoid_print
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        String username = '', imageUrl = '';
        try {
          TalkProfile profile = await TalkApi.instance.profile();
          // ignore: avoid_print
          print('카카오톡 프로필 받기 성공'
              '\n닉네임: ${profile.nickname}'
              '\n프로필사진: ${profile.thumbnailUrl}');
          username = profile.nickname!;
          imageUrl = profile.thumbnailUrl!;
        } catch (error) {
          // ignore: avoid_print
          print('카카오톡 프로필 받기 실패 $error');
        }
        _isLoggedIn = true;
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              groups: const ["전체", "도란도란 용규네 자취방", "본가"],
              username: username,
              imageURL: imageUrl,
            ),
          ),
        );
      } catch (error) {
        // ignore: avoid_print
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }
}
