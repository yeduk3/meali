import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color(0xFF168AFF),
                textStyle: FontSystem.button14,
                foregroundColor: ColorSystem.white,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
