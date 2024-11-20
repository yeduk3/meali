import 'package:flutter/material.dart';
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
    ImageProvider<Object> imageProv =
        isNetwork ? NetworkImage(imageURL) : AssetImage(imageURL);

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

class UserAddButton extends StatelessWidget {
  const UserAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const ShapeDecoration(
        shape: OvalBorder(),
        color: ColorSystem.gray10,
        shadows: ColorSystem.shadow,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Image.asset(
          "assets/images/add_user_icon.png",
          width: 18,
        ),
      ),
    );
  }
}
