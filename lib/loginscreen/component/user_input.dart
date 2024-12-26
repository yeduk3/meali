import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class InputText extends StatelessWidget {
  final String hintText;
  const InputText({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorSystem.gray09,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: hintText,
          hintStyle: FontSystem.inputStyle,
        ),
      ),
    );
  }
}

class InputFilledButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final Function() onPressed;

  const InputFilledButton({
    super.key,
    required this.title,
    this.backgroundColor = ColorSystem.brandColor,
    this.textColor = ColorSystem.white,
    this.textStyle = FontSystem.inputStyle,
    required this.onPressed,
  });

  const InputFilledButton.kakao({
    super.key,
    this.title = "카카오톡 로그인",
    this.backgroundColor = const Color(0xFFFBE400),
    this.textColor = ColorSystem.black,
    this.textStyle = FontSystem.kakaoInput,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
              onPressed: onPressed,
              child: Text(
                title,
                style: textStyle.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InputTextButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const InputTextButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        overlayColor: ColorSystem.gray04,
      ),
      child: Text(
        title,
        style: FontSystem.name14.copyWith(
          color: ColorSystem.gray04,
        ),
      ),
    );
  }
}
