import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class ExpandableButton extends StatelessWidget {
  const ExpandableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.gray09,
                foregroundColor: ColorSystem.black,
                textStyle: FontSystem.button14,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/write_icon.png',
                    width: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text('새 메모 작성하기'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
