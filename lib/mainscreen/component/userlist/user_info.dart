import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/mainscreen/component/userlist/user_image.dart';
import 'package:meali/static/font_system.dart';

class UserInfo extends StatelessWidget {
  /// width and height of icon
  final double iconSize;

  /// width(or height in case of direction = false) between icon and text
  final double betweenSpace;

  /// true = vertical, false = horizontal
  final bool direction;

  /// user data(name, thumbnailUrl)
  final UserData userdata;

  /// TextStyle which is applied to Text name
  final TextStyle style;

  /// [Debug]
  final bool isNetwork;

  const UserInfo({
    super.key,
    required this.iconSize,
    required this.betweenSpace,
    required this.direction,
    required this.userdata,
    required this.style,
    this.isNetwork = true,
  });

  const UserInfo.vertical({
    super.key,
    this.iconSize = 48,
    this.betweenSpace = 2,
    this.direction = true,
    required this.userdata,
    required this.style,
    this.isNetwork = true,
  });

  const UserInfo.horizontal({
    super.key,
    this.iconSize = 28,
    this.betweenSpace = 8,
    this.direction = false,
    required this.userdata,
    this.style = FontSystem.name14,
    this.isNetwork = true,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction ? Axis.vertical : Axis.horizontal,
      children: [
        UserImage(
          size: iconSize,
          imageURL: userdata.thumbnailUrl,
          isNetwork: isNetwork,
        ),
        SizedBox(
          height: betweenSpace,
          width: betweenSpace,
        ),
        SizedBox(
          height: direction ? 26 : 20,
          child: Center(
            child: Text(
              userdata.username,
              style: style,
            ),
          ),
        )
      ],
    );
  }
}
