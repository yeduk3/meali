import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/mainscreen/component/group_usercount_badge.dart';
import 'package:meali/static/font_system.dart';

class GroupInfoListTile extends StatelessWidget {
  const GroupInfoListTile({
    super.key,
    required this.sameGroupUsersCount,
    required this.groupName,
    required this.checked,
  });

  final int sameGroupUsersCount;
  final String groupName;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              groupName,
              style: FontSystem.button14,
            ),
            const SizedBox(width: 8),
            GroupUserCountBadge(sameGroupUsersCount: sameGroupUsersCount)
          ],
        ),
        checked
            ? Image.asset(
                "assets/images/selected_icon.png",
                width: 24,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
