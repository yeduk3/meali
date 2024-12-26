import 'package:flutter/material.dart';
import 'package:meali/common/group_content.dart';
import 'package:meali/common/group_info.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/mainscreen/blue_button.dart';
import 'package:meali/mainscreen/bottomsheet/groupinfo_tilelist.dart';
import 'package:meali/mainscreen/bottomsheet/option_mealimodalbottomsheetchild.dart';
import 'package:meali/mainscreen/component/expandable_button.dart';
import 'package:meali/mainscreen/component/meali_modal_bottom_sheet.dart';
import 'package:meali/mainscreen/component/memo/memo.dart';
import 'package:meali/mainscreen/component/userlist/userlist_in_same_group.dart';
import 'package:meali/loginscreen/login_controller.dart';
import 'package:meali/mainscreen/data_loader.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedValue;

  // Future<List<UserData>> sameGroupUsers;
  // Future<List<GroupContent>> sameGroupContent;
  // Future<List<GroupInfo>> groupInfos;
  List<UserData> sameGroupUsers = [];
  List<GroupContent> sameGroupContent = [];
  List<GroupInfo> groupInfos = [];

  final ScrollController _memoListController = ScrollController();
  final TextEditingController _memoEditController = TextEditingController();

  void _scrollToHead() {
    _memoListController.animateTo(
      _memoListController.position.maxScrollExtent,
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

  void _checkMyUserData() {
    try {
      DataLoader();
    } catch (error) {
      context.go("/login");
    }
    if (DataLoader().getMyUserData() == null) {
      context.go("/login");
    }
  }

  Future<void> dataRefresh() async {
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
  }

  @override
  void initState() {
    super.initState();

    _checkMyUserData();

    // groupInfos = DataLoader().getGroupList();
    // sameGroupUsers = DataLoader().getSameGroupUserData(groupNameListReceiver[0].groupID);
    // sameGroupContent = DataLoader().getGroupContent(groupNameListReceiver[0].groupID);

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
          UserListInSameGroup(
            sameGroupUsers: sameGroupUsers,
            myData: DataLoader().getMyUserData()!,
          ),

          /// [Contents]
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20, top: 20),
          //   child: Column(
          //     children: [
          //       TextField(
          //         onSubmitted: (value) async {
          //           var gID = groupInfos.firstWhere((element) => element.groupName == selectedValue).groupID;
          //           await DataLoader().postData(gID, value);
          //           await _updateSameGroupContent(gID);
          //           _scrollToHead(); // TODOooo: 작동 안 됨. -> 해결
          //         },
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExpandableButton(
              controller: _memoEditController,
              onSubmitted: () async {
                var value = _memoEditController.text;
                if (value == "") return;

                var gID = groupInfos.firstWhere((element) => element.groupName == selectedValue).groupID;
                await DataLoader().postData(gID, value);
                await _updateSameGroupContent(gID);

                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToHead(),
                );

                _memoEditController.text = "";
              },
            ),
          ),
          const SizedBox(height: 12),

          /// [Memo List with ReorderableListView]
          Expanded(
            child: SizedBox(
              child: ReorderableListView(
                clipBehavior: Clip.antiAlias,
                // top 12 for displaying shadow of memo
                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 12, top: 12),
                scrollController: _memoListController,
                reverse: true,
                shrinkWrap: true,
                onReorder: (oldIndex, newIndex) {},
                children: sameGroupContent
                    .map((e) => Memo(
                          key: ValueKey(e.contentID),
                          title: e.content,
                          userdata: DataLoader().getMyUserData()!,
                          timeStamp: DateTime.now(),
                          content: true,
                        ))
                    .toList(),
              ),
            ),
          ),
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
        onPressed: showMealiModalBottomSheet(
          context: context,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: () {
                List<Widget> list = groupInfos.map<Widget>(groupInfosMapper).toList();
                list.addAll([
                  const SizedBox(height: 20),

                  /// [집 추가하기 버튼]
                  BlueButton(
                    onPressed: openCreateGroupDialog,
                    child: const Text("+ 집 추가하기"),
                  )
                ]);
                return list;
              }(),
            ),
          ),
        ),
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
      actions: [
        IconButton(
          onPressed: showMealiModalBottomSheet(
            context: context,
            child: OptionMealiModalBottomSheetChild(context: context),
          ),
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

  Widget groupInfosMapper(e) => ListTile(
        title: GroupInfoListTile(
          sameGroupUsers: sameGroupUsers,
          groupName: e.groupName,
          checked: selectedValue == e.groupName,
        ),
        onTap: () {
          setState(() {
            selectedValue = e.groupName;
          });
          int groupID = groupInfos.firstWhere((group) => group.groupName == selectedValue).groupID;
          _updateSameGroupContent(groupID);
          Navigator.pop(context);
        },
      );

  final TextEditingController _groupNameInputController = TextEditingController();

  void openCreateGroupDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: ColorSystem.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            "집 추가하기",
            style: FontSystem.memoTitle,
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "집 이름을 작성해주세요",
              hintStyle: FontSystem.content14,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            controller: _groupNameInputController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // DataLoader().createNewGroupByName(_groupNameInputController.text);
                await DataLoader().createAndJoinNewGroupByName(_groupNameInputController.text);
                if (context.mounted) {
                  context.pop();
                  context.pop();
                }
                await dataRefresh();
              },
              child: const Text("생성하기"),
            ),
          ],
        ),
      );
}
