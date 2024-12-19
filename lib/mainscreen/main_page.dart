import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meali/common/group_content.dart';
import 'package:meali/common/group_info.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/component/memo.dart';
import 'package:meali/component/user_image.dart';
import 'package:meali/mainscreen/data_loader.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';
import 'package:meali/component/customdropdown.dart' as customdropdown;
import 'package:meali/component/user_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedValue;

  List<UserData> sameGroupUsers = [];
  List<GroupContent> sameGroupContent = [];
  List<GroupInfo> groupInfos = [];

  final ScrollController _controller = ScrollController();

  void _scrollToHead() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.bounceOut,
    );
  }

  Future<void> _updateSameGroupContent(int groupID) async {
    List<GroupContent> sameGroupContentReceiver = [];
    sameGroupContentReceiver = await DataLoader().getGroupContent(groupID);
    setState(() {
      sameGroupContent = sameGroupContentReceiver;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        List<GroupInfo> groupNameListReceiver = await DataLoader().getGroupList();
        List<UserData> sameGroupUsersReceiver = [];
        List<GroupContent> sameGroupContentReceiver = [];

        if (groupNameListReceiver.isNotEmpty) {
          sameGroupUsersReceiver = await DataLoader().getSameGroupUserData(groupNameListReceiver[0].groupID);
          sameGroupContentReceiver = await DataLoader().getGroupContent(groupNameListReceiver[0].groupID);
        }

        setState(() {
          groupInfos = groupNameListReceiver;
          sameGroupUsers = sameGroupUsersReceiver;
          sameGroupContent = sameGroupContentReceiver;
          selectedValue = groupInfos.firstOrNull?.groupName;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) print("User ID: ${DataLoader().myUserData.userId}");
    return Scaffold(
      /// [AppBar]
      appBar: mealiAppBar(),

      /// [Body]
      body: Column(
        children: [
          /// [User List in Group]
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: ColorSystem.gray09),
              ),
            ),
            height: 108,
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 11,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfo.vertical(
                  style: FontSystem.nameme12,
                  isNetwork: true,
                  userdata: DataLoader().myUserData,
                ),
                Row(
                  children: sameGroupUsers
                      .map(
                        (e) => Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
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
                const UserAddButton(),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20, top: 20),
              // child: ExpandableButton(),
              child: Column(
                children: [
                  TextField(
                    onSubmitted: (value) async {
                      var gID = groupInfos.firstWhere((element) => element.groupName == selectedValue).groupID;
                      await DataLoader().postData(gID, value);
                      await _updateSameGroupContent(gID);
                      _scrollToHead();
                    },
                  )
                ],
              )),

          /// [Memo List with ReorderableListView]
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 12, top: 0),
              child: ReorderableListView(
                scrollController: _controller,
                reverse: true,
                onReorder: (oldIndex, newIndex) {},
                children: sameGroupContent
                    .map((e) => Memo(
                          key: ValueKey(e.contentID),
                          title: e.content,
                          userdata: DataLoader().myUserData,
                          timeStamp: DateTime.now(),
                          content: true,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// [AppBar]

  AppBar mealiAppBar() {
    return AppBar(
      toolbarHeight: 54,
      titleSpacing: 0,
      title: TextButton(
        style: TextButton.styleFrom(
          overlayColor: ColorSystem.black,
          shape: const LinearBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: showGroupListModal,
        child: Row(
          children: [
            Text(
              selectedValue ?? "그룹이 없습니다",
              style: FontSystem.title,
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
        ),
      ),
      // customdropdown.DropdownButton<String>(
      //   value: selectedValue,
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   elevation: 0,
      //   isExpanded: true,
      //   style: FontSystem.title,
      //   underline: const SizedBox(),
      //   dropdownColor: ColorSystem.white,
      //   icon: const SizedBox.shrink(),
      //   selectedItemBuilder: (context) => _appBarSelectedItemBuilder(
      //     context,
      //     groupInfos.map((e) => e.groupName).toList(),
      //   ), // when selected, auto callback
      //   items: _appBarDropdownMenuItemBuilder(
      //     groupInfos.map((e) => e.groupName).toList(),
      //   ),
      //   onChanged: (String? value) async {
      //     int i = 0;
      //     for (; i < groupInfos.length; ++i) {
      //       if (groupInfos[i].groupName == value) break;
      //     }
      //     List<UserData> sameGroupUsersReceiver = [];
      //     List<GroupContent> sameGroupContentReceiver = [];
      //     if (groupInfos[i].groupName != selectedValue) {
      //       sameGroupUsersReceiver = await DataLoader().getSameGroupUserData(groupInfos[i].groupID);
      //       sameGroupContentReceiver = await DataLoader().getGroupContent(groupInfos[i].groupID);
      //     }

      //     setState(() {
      //       selectedValue = value!;
      //       sameGroupUsers = sameGroupUsersReceiver;
      //       sameGroupContent = sameGroupContentReceiver;
      //     });
      //   },
      // ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/images/hamburger_icon.png",
            width: 20,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void showGroupListModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorSystem.white,
      builder: (context) => Wrap(
        children: [
          Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            ),
            // height: 28 + groupInfos.length * 48 + 24,
            child: Column(
              children: [
                SizedBox(
                  height: 28,
                  child: Center(
                    child: Container(
                      width: 56,
                      height: 4,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFCAD3DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: () {
                      List<Widget> list = groupInfos
                          .map<Widget>(
                            (e) => ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    e.groupName,
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
                              ),
                              onTap: () {
                                setState(() {
                                  selectedValue = e.groupName;
                                });
                                int groupID = groupInfos.firstWhere((group) => group.groupName == selectedValue).groupID;
                                _updateSameGroupContent(groupID);
                                Navigator.pop(context);
                              },
                            ),
                          )
                          .toList();
                      list.addAll([
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    backgroundColor: const Color(0xFF168AFF),
                                    textStyle: FontSystem.button14,
                                    foregroundColor: ColorSystem.white,
                                  ),
                                  child: const Text("+ 집 추가하기"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]);
                      return list;
                    }(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<customdropdown.DropdownMenuItem<String>> _appBarDropdownMenuItemBuilder(List<String> groups) {
    return groups.map<customdropdown.DropdownMenuItem<String>>(
      (groupName) {
        return customdropdown.DropdownMenuItem<String>(
          value: groupName,
          child: Text(
            groupName,
            style: const TextStyle(color: ColorSystem.black),
          ),
        );
      },
    ).toList();
  }

  List<Widget> _appBarSelectedItemBuilder(context, List<String> groups) {
    return groups.map<Widget>(
      (e) {
        return Row(
          children: [
            Text(
              e,
              style: const TextStyle(color: ColorSystem.black),
            ),
            const SizedBox(width: 4),
            Image.asset(
              "assets/images/arrow_drop_down_icon.png",
              width: 18,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: const BoxDecoration(color: ColorSystem.gray09, borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/users_icon.png",
                    width: 12,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    groupInfos.length.toString(),
                    style: FontSystem.count,
                  ),
                ],
              ),
            )
          ],
        );
      },
    ).toList();
  }
}
