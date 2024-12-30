import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meali/common/group_info.dart';
import 'package:meali/invitedscreen/invited_controller.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/mainscreen/data_loader.dart';

class InvitedScreen extends StatefulWidget {
  const InvitedScreen({
    super.key,
    required this.groupId,
  });

  final int groupId;

  @override
  State<InvitedScreen> createState() => _InvitedScreenState();
}

class _InvitedScreenState extends State<InvitedScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      GroupInfo? result = await InvitedController.invitedFrom(widget.groupId);
      if (mounted) {
        if (result != null) {
          context.go('/mainpage', extra: result);
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invited group to groupId = ${widget.groupId}")),
      body: const CircularProgressIndicator(),
    );
  }
}
