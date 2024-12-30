import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:meali/static/color_system.dart';

class UserAddButton extends StatelessWidget {
  const UserAddButton({
    super.key,
    required this.username,
    required this.groupId,
  });

  final String username;
  final int groupId;

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
        onPressed: groupId > 0 ? shareGroupLinkToKakaoFriend : null,
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
        webUrl: Uri.parse('https://yeduk3.github.io/userinvitation/$groupId'),
        mobileWebUrl: Uri.parse('https://yeduk3.github.io/userinvitation/$groupId'),
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
