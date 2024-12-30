import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class GroupUserCountBadge extends StatelessWidget {
  const GroupUserCountBadge({
    super.key,
    required this.sameGroupUsersCount,
  });

  final int sameGroupUsersCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: ColorSystem.gray10,
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/users_icon.png",
            width: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$sameGroupUsersCount',
            style: FontSystem.count,
          ),
        ],
      ),
    );
  }
}
