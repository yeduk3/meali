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

class UserAddButton extends StatelessWidget {
  const UserAddButton({
    super.key,
    required this.username,
  });

  final String username;

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
        onPressed: shareGroupLinkToKakaoFriend,
        icon: Image.asset(
          "assets/images/add_user_icon.png",
          width: 18,
        ),
      ),
    );
  }

  void shareGroupLinkToKakaoFriend() async {
    // Text Template for sharing
    final TextTemplate defaultText = TextTemplate(
      text: '$username님이 그룹에 초대했어요!\n메모를 공유해보세요!',
      link: Link(
        webUrl: Uri.parse('https: //developers.kakao.com'),
        mobileWebUrl: Uri.parse('https: //developers.kakao.com'),
      ),
      buttonTitle: "그룹 들어가기",
    );

    // 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: defaultText);
        await ShareClient.instance.launchKakaoTalk(uri);
        if (kDebugMode) print('카카오톡 공유 완료');
      } catch (error) {
        if (kDebugMode) print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: defaultText);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        if (kDebugMode) print('카카오톡 공유 실패 $error');
      }
    }
  }
}
