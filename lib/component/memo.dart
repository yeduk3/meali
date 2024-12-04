import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/component/checkboxtile.dart';
import 'package:meali/component/user_info.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class Memo extends StatelessWidget {
  /// title of memo
  final String title;

  /// user data(name, thumbnailUrl)
  final UserData userdata;

  /// edit time
  final DateTime timeStamp;

  /// [Test] content exist
  final bool content;

  const Memo({
    super.key,
    required this.title,
    required this.userdata,
    required this.timeStamp,
    required this.content,
  });

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
      child: Column(
        children: [
          /// [Header]
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: FontSystem.memoTitle,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),

          /// [Content]
          if (content)
            const Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                CheckBoxTile(),
                CheckBoxTile(),
                CheckBoxTile(),
              ],
            )
          else
            const SizedBox.shrink(),

          /// [Bottom]
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserInfo.horizontal(userdata: userdata),
              Text(timeStamp.toString())
            ],
          ),
        ],
      ),
    );
  }
}
