import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:meali/component/user_input.dart';
import 'package:meali/screen/main_page.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/temp_icon.png"),
              const SizedBox(height: 12),
              const Text(
                "메아리",
                style: FontSystem.appNameTitle,
              ),
              const SizedBox(height: 60),
              const InputText(hintText: "아이디를 입력하세요"),
              const SizedBox(height: 8),
              const InputText(hintText: "비밀번호를 입력하세요"),
              const SizedBox(height: 12),
              // const InputFilledButton(title: "로그인"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InputTextButton(
                      title: "회원가입",
                      onPressed: () {},
                    ),
                    InputTextButton(
                      title: "아이디 찾기",
                      onPressed: () {},
                    ),
                    InputTextButton(
                      title: "비밀번호 찾기",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              InputFilledButton.kakao(
                onPressed: () async {
                  if (await isKakaoTalkInstalled()) {
                    try {
                      OAuthToken token =
                          await UserApi.instance.loginWithKakaoTalk();
                      // ignore: avoid_print
                      print('카카오톡으로 로그인 성공 ${token.accessToken}');
                    } catch (error) {
                      // ignore: avoid_print
                      print('카카오톡으로 로그인 실패 $error');
                    }
                  } else {
                    try {
                      OAuthToken token =
                          await UserApi.instance.loginWithKakaoAccount();
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
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
