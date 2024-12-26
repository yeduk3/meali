import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meali/loginscreen/component/user_input.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = LoginController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() async {
    if (await loginController.haskakaoLoginToken()) {
      if (kDebugMode) print('Token exists');
      // if context is mounted
      if (mounted) {
        context.go("/mainpage");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MainPage(),
        //   ),
      } else {
        throw Exception('Context is not mounted');
      }
    }
  }

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
                  bool isLoginSuccess = await LoginController().loginWithKakao(context);

                  // mount: 비동기 작업 간, 위젯이 여전히 활성되어있는지 체크
                  if (isLoginSuccess && context.mounted) {
                    /// [Page Move]
                    context.go("/mainpage");
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const MainPage(),
                    //   ),
                    // );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
