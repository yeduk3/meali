import 'package:flutter/material.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/static/font_system.dart';
import 'package:go_router/go_router.dart';

class OptionMealiModalBottomSheetChild extends StatelessWidget {
  const OptionMealiModalBottomSheetChild({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                "개인정보 설정",
                style: FontSystem.button14,
              ),
              // TODO
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                "우리집 관리",
                style: FontSystem.button14,
              ),
              // TODO
              onTap: () {},
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                "로그아웃",
                style: FontSystem.button14.copyWith(color: Colors.red),
              ),
              onTap: () {
                LoginController().logout();
                context.go("/login");
              },
            ),
            ListTile(
              title: Text(
                "계정 삭제",
                style: FontSystem.button14.copyWith(color: Colors.red),
              ),
              onTap: () {
                LoginController().deleteAccount();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
