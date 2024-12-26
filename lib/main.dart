import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:meali/loginscreen/login_page.dart';
import 'package:meali/mainscreen/main_page.dart';
import 'package:meali/static/color_system.dart';

void main() async {
  await dotenv.load();
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorSystem.white,
          foregroundColor: ColorSystem.gray01,
          surfaceTintColor: ColorSystem.white,
        ),
      ),
      routerConfig: _router,
      // home: const LoginPage(),
    );
  }
}

/// This handles '/' and '/details'.
final _router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: "/mainpage",
      builder: (_, __) => const MainPage(),
      routes: [
        GoRoute(
          path: '/userinvitation',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('INvitation Screen')),
          ),
        ),
      ],
    ),
  ],
);
