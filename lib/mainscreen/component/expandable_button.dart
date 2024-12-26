import 'package:flutter/material.dart';
import 'package:meali/mainscreen/blue_button.dart';
import 'package:meali/mainscreen/component/memo/memo_container.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class ExpandableButton extends StatefulWidget {
  ExpandableButton({
    super.key,
    this.onSubmitted,
    this.controller,
  });
  TextEditingController? controller;
  void Function()? onSubmitted;

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool? _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.medium1,
      child: _isExpanded!
          ? MemoContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: 132,
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "메모를 입력하세요.",
                        hintStyle: FontSystem.content14.copyWith(color: ColorSystem.gray03),
                      ),
                      autofocus: true,
                      style: FontSystem.content14,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  BlueButton(
                    onPressed: () {
                      widget.onSubmitted?.call();
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    child: const Text("등록하기"),
                  ),
                ],
              ),
            )
          : SizedBox(
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
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded!;
                        });
                      },
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
            ),
    );
  }
}
