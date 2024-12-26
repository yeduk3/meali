import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/component/user_image.dart';
import 'package:meali/component/user_info.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class UserListInSameGroup extends StatelessWidget {
  const UserListInSameGroup({
    super.key,
    required this.sameGroupUsers,
    required this.myData,
  });

  final List<UserData> sameGroupUsers;
  final UserData myData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ColorSystem.gray09))),
      height: 108,
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfo.vertical(
            style: FontSystem.nameme12,
            isNetwork: true,
            userdata: myData,
          ),
          Row(
            children: sameGroupUsers
                .map(
                  (e) => Row(
                    children: [
                      const SizedBox(width: 15),
                      UserInfo.vertical(
                        userdata: e,
                        style: FontSystem.nameother12,
                      )
                    ],
                  ),
                )
                .toList(),
          ),

          /// [User Add Button] Last space is 12
          const SizedBox(
            width: 12,
          ),
          UserAddButton(username: myData.username),
        ],
      ),
    );
  }
}
