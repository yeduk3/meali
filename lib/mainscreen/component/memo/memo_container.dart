import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';

class MemoContainer extends StatelessWidget {
  const MemoContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ColorSystem.shadow,
      ),
      child: child,
    );
  }
}
