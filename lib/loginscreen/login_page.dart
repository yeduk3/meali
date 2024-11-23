import 'package:flutter/material.dart';
import 'package:meali/component/user_input.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  LoginController loginController = LoginController();

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
                  loginController.loginWithKakao(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
