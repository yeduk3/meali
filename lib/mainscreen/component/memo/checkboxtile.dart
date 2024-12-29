import 'package:flutter/material.dart';
import 'package:meali/mainscreen/component/userlist/user_image.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class CheckBoxTile extends StatefulWidget {
  const CheckBoxTile({
    super.key,
    required this.content,
    required this.checked,
  });

  final String content;
  final bool checked;

  @override
  State<CheckBoxTile> createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// [Left]
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  splashRadius: 0,
                  side: const BorderSide(color: ColorSystem.gray07),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.content,
                style: FontSystem.content14,
              ),
            ],
          ),

          /// [Right]
          if (_isChecked)
            const UserImage(
              size: 20,
            )
        ],
      ),
    );
  }
}
