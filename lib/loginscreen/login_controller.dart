import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:meali/mainscreen/data_loader.dart';
import 'package:meali/mainscreen/main_page.dart';
import 'package:meali/common/user_data.dart';

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

  /// Login Status
  bool _isLoggedIn = false;

  /// ReadOnly, Login Status
  bool get isLoggedIn => _isLoggedIn;

  void loginWithKakao(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      /// [KakaoTalk Installed]
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // ignore: avoid_print
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        // ignore: avoid_print
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      /// [KakaoTalk Not Installed]
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        // ignore: avoid_print
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        String username = '', thumbnailUrl = '';
        try {
          TalkProfile profile = await TalkApi.instance.profile();
          // ignore: avoid_print
          print('카카오톡 프로필 받기 성공'
              '\n닉네임: ${profile.nickname}'
              '\n프로필사진: ${profile.thumbnailUrl}');
          username = profile.nickname!;
          thumbnailUrl = profile.thumbnailUrl!;
        } catch (error) {
          // ignore: avoid_print
          print('카카오톡 프로필 받기 실패 $error');
        }

        /// [Status]
        await _updateLogInStatus(username, thumbnailUrl);

        /// [Page Move]
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              groups: ["전체", "자취방", "본가"],
            ),
          ),
        );
      } catch (error) {
        // ignore: avoid_print
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> _updateLogInStatus(String username, String thumbnailUrl) async {
    _isLoggedIn = true;
    User me = await UserApi.instance.me();
    // ignore: unused_local_variable
    DataLoader dataLoader = DataLoader.from(
      UserData(
        userId: me.id,
        username: username,
        thumbnailUrl: thumbnailUrl,
      ),
    );
  }
}
