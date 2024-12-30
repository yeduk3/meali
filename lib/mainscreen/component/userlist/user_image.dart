import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:meali/static/color_system.dart';

class UserImage extends StatelessWidget {
  final double size;

  final String imageURL;

  final bool isNetwork;

  const UserImage({
    super.key,
    this.size = 48.0,
    this.imageURL = "assets/images/test_user_image.jpeg",
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProv = isNetwork ? NetworkImage(imageURL) : AssetImage(imageURL);

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: const OvalBorder(),
        image: DecorationImage(
          image: imageProv,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
