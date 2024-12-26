import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/static/font_system.dart';

class GroupInfoListTile extends StatelessWidget {
  const GroupInfoListTile({
    super.key,
    required this.sameGroupUsers,
    required this.groupName,
  });

  final List<UserData> sameGroupUsers;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          groupName,
          style: FontSystem.button14,
        ),
        const SizedBox(width: 8),
        Image.asset(
          "assets/images/users_icon.png",
          width: 12,
        ),
        const SizedBox(width: 4),
        Text(
          (sameGroupUsers.length + 1).toString(),
          style: FontSystem.count,
        ),
      ],
    );
  }
}
