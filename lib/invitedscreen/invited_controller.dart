import 'package:meali/common/group_info.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/mainscreen/data_loader.dart';

class InvitedController {
  // InvitedController._privateConstructor();

  // static final InvitedController _instance = InvitedController._privateConstructor();

  // factory InvitedController() {
  //   return _instance;
  // }

  static Future<GroupInfo?> invitedFrom(int groupId) async {
    var hasToken = await LoginController().haskakaoLoginToken();
    GroupInfo? groupInfo;
    if (hasToken) {
      var status = await DataLoader().joinGroup(groupId);
      if (status == 200) {
        // success
        groupInfo = await DataLoader().findGroupById(groupId);
      } else {
        // fail -> go login
      }
    } else {
      // fail -> go login
    }
    return groupInfo;
  }
}
