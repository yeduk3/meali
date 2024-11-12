import 'package:flutter/material.dart';
import 'package:meali/screen/main_page.dart';
import 'package:meali/static/color_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorSystem.white,
            foregroundColor: ColorSystem.gray01,
          ),
        ),
        home: const MainPage(
          groups: ["전체", "도란도란 용규네 자취방", "본가"],
        ));
  }
}
