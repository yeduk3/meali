import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meali/common/group_content.dart';
import 'package:meali/common/group_info.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/common/component/blue_button.dart';
import 'package:meali/mainscreen/bottomsheet/groupinfo_tilelist.dart';
import 'package:meali/mainscreen/bottomsheet/option_mealimodalbottomsheetchild.dart';
import 'package:meali/mainscreen/component/memo/expandable_button.dart';
import 'package:meali/mainscreen/component/appbar/group_usercount_badge.dart';
import 'package:meali/mainscreen/bottomsheet/meali_modal_bottom_sheet.dart';
import 'package:meali/mainscreen/component/memo/memo.dart';
import 'package:meali/mainscreen/component/userlist/userlist_in_same_group.dart';
import 'package:meali/mainscreen/data_loader.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';
import 'package:go_router/go_router.dart';

// /// key: int groupId
// ///
// /// value: List\<int\> contentOrder
// typedef ContentOrderMap = Map<int, List<int>>;

class MainPage extends StatefulWidget {
  MainPage({
    super.key,
    this.startgroup,
  });

  GroupInfo? startgroup;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final _storage = const FlutterSecureStorage();

  // ContentOrderMap _contentOrderMap = {};

  // IOSOptions _getIOSOptions() => const IOSOptions();

  // AndroidOptions _getAndroidOptions() => const AndroidOptions();

  // Future<Map<int, List<int>>> _readContentOrderAll() async {
  //   try {
  //     final all = await _storage.readAll(
  //       iOptions: _getIOSOptions(),
  //       aOptions: _getAndroidOptions(),
  //     );
  //     final contentOrder = all["ContentOrder"]!;
  //     setState(() {
  //       _contentOrderMap = jsonDecode(contentOrder).cast<int, List<int>>();
  //     });
  //     if (kDebugMode) print("오더맵: ${_contentOrderMap.toString()}");
  //     return _contentOrderMap;
  //   } catch (exception) {
  //     if (kDebugMode) print("ContentOrder 읽기 실패 $exception");
  //     return {};
  //   }
  // }

  // /// Put all contents in a group
  // ///
  // /// no groupid -> create.
  // ///
  // /// exist groupid -> overwirte. If join is true, not overwrite but insert into beginning
  // Future<void> _writeContentOrderOf(int groupId, List<int> contentIds, [bool? join]) async {
  //   setState(() {
  //     if (_contentOrderMap.containsKey(groupId)) {
  //       if (join ?? true) {
  //         // join is null or false
  //         _contentOrderMap[groupId] = contentIds;
  //       } else {
  //         // join is true
  //         _contentOrderMap[groupId]!.insertAll(0, contentIds);
  //       }
  //     } else {
  //       _contentOrderMap.addAll({groupId: contentIds});
  //     }
  //   });
  //   await _storage.write(key: "ContentOrder", value: _contentOrderMap.toString());
  // }

  // Future<void> _swapContentOrderAll(int groupId, int oldIndex, int newIndex) async {
  //   try {
  //     int? temp = _contentOrderMap[groupId]?[oldIndex];
  //     _contentOrderMap[groupId]![oldIndex] = _contentOrderMap[groupId]![newIndex];
  //     _contentOrderMap[groupId]![newIndex] = temp!;

  //     await _writeContentOrderOf(groupId, _contentOrderMap[groupId]!);
  //   } catch (exception) {
  //     if (kDebugMode) print("리스트 스왑 실패 그룹 $groupId, tried to swap $oldIndex and $newIndex");
  //   }
  // }

  GroupInfo? selectedValue;

  List<UserData> sameGroupUsers = [];
  List<GroupContent> sameGroupContent = [];
  List<GroupInfo> groupInfos = [];

  final ScrollController _memoListController = ScrollController();
  final TextEditingController _memoEditController = TextEditingController();

  bool _isMemoDragging = false;
  bool _isMemoOverTrashBin = false;

  void _checkMyUserDataExist() {
    try {
      DataLoader();
    } catch (error) {
      context.go("/login");
    }
    if (DataLoader().getMyUserData() == null) {
      context.go("/login");
    }
  }

  Future<void> _updateSameGroupContent(int groupID) async {
    List<GroupContent> sameGroupContentReceiver = await DataLoader().getGroupContent(groupID);
    setState(() {
      sameGroupContent = sameGroupContentReceiver;
    });
  }

  Future<void> _updateSameGroupUser(int groupID) async {
    List<UserData> sameGroupContentReceiver = await DataLoader().getSameGroupUserData(groupID);
    setState(() {
      sameGroupUsers = sameGroupContentReceiver;
    });
  }

  Future<void> _dataRefresh([int? currentGroupId]) async {
    // _readContentOrderAll();
    List<GroupInfo> groupInfosReceiver = await DataLoader().getGroupList();
    setState(() {
      groupInfos = groupInfosReceiver;
    });

    if (groupInfosReceiver.isNotEmpty) {
      var selectedGroup = currentGroupId == null
          ? groupInfosReceiver.first
          : groupInfosReceiver.firstWhere(
              (element) => element.groupID == currentGroupId,
              orElse: () => groupInfosReceiver.first,
            );
      await _updateSameGroupContent(selectedGroup.groupID);
      await _updateSameGroupUser(selectedGroup.groupID);
      setState(() {
        selectedValue = selectedGroup;
      });
    } else {
      setState(() {
        sameGroupContent = [];
        sameGroupUsers = [];
        selectedValue = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() => selectedValue = widget.startgroup);

    _checkMyUserDataExist();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        // await _writeContentOrderOf(1, [123, 1232, 2222]);
        // await _readContentOrderAll();
        await _dataRefresh();
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
            groupId: selectedValue?.groupID ?? -1,
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
            child: groupInfos.isEmpty
                ? Text(
                    "그룹을 생성해주세요.",
                    style: FontSystem.content14.copyWith(color: ColorSystem.gray03),
                  )
                : ExpandableButton(
                    controller: _memoEditController,
                    onSubmitted: () async {
                      var value = _memoEditController.text;
                      if (value == "") return;

                      var gID = groupInfos.firstWhere((element) => element.groupID == selectedValue?.groupID).groupID;
                      await DataLoader().postContent(gID, value);
                      await _updateSameGroupContent(gID);

                      // Go Up to see New one
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => () {
                          _memoListController.animateTo(
                            _memoListController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInCubic,
                          );
                        }(),
                      );

                      _memoEditController.text = "";
                    },
                  ),
          ),

          /// [Memo List with ReorderableListView]
          Expanded(
            child: Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(20.0),
                  controller: _memoListController,
                  shrinkWrap: true,
                  itemCount: sameGroupContent.length,
                  itemBuilder: (context, index) => Memo(
                    key: ValueKey(sameGroupContent[index].contentID),
                    source: sameGroupContent[index].content,
                    userdata: DataLoader().getMyUserData()!,
                    timeStamp: DateTime.now(),
                    dragOptions: MemoDragOptions<int>(
                      onDragStarted: () => setState(() => _isMemoDragging = true),
                      onDragEnd: (_) => setState(() => _isMemoDragging = false),
                      data: sameGroupContent[index].contentID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                ),
                Align(
                  alignment: const Alignment(0.0, 0.8),
                  child: _isMemoDragging
                      ? DragTarget(
                          builder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: _isMemoOverTrashBin ? Colors.red : ColorSystem.gray07,
                            ),
                            child: const Center(child: Text("제거하기")),
                          ),
                          onWillAcceptWithDetails: (details) {
                            setState(() => _isMemoOverTrashBin = true);
                            return true;
                          },
                          onLeave: (_) => setState(() => _isMemoOverTrashBin = false),
                          onAcceptWithDetails: (details) async {
                            setState(() => _isMemoOverTrashBin = false);
                            DataLoader().deleteContent(int.parse(details.data!.toString()));
                            await _updateSameGroupContent(selectedValue!.groupID);
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ],
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
              selectedValue?.groupName ?? "그룹이 없습니다",
              style: FontSystem.title,
            ),
            const SizedBox(width: 8),
            selectedValue == null
                ? const SizedBox.shrink()
                : GroupUserCountBadge(
                    sameGroupUsersCount: sameGroupUsers.length + 1,
                  ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: showMealiModalBottomSheet(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  BlueButton(
                    child: const Text("그룹 나가기"),
                    onPressed: () async {
                      await DataLoader().leaveGroupBy(selectedValue!.groupID);
                      await _dataRefresh();
                      if (mounted) {
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  BlueButton(
                    child: const Text("그룹 삭제"),
                    onPressed: () async {
                      await DataLoader().deleteGroupById(selectedValue!.groupID);
                      await _dataRefresh();
                      if (mounted) {
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          icon: Image.asset(
            "assets/images/write_icon.png",
            width: 24,
            height: 24,
          ),
        ),
        IconButton(
          onPressed: showMealiModalBottomSheet(
            context: context,
            child: OptionMealiModalBottomSheetChild(context: context),
          ),
          icon: Image.asset(
            "assets/images/hamburger_icon.png",
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget groupInfosMapper(e) => ListTile(
        title: GroupInfoListTile(
          sameGroupUsersCount: sameGroupUsers.length + 1,
          groupName: e.groupName,
          checked: selectedValue?.groupID == e.groupID,
        ),
        onTap: () {
          setState(() {
            selectedValue = e;
          });
          int groupID = groupInfos.firstWhere((group) => group.groupID == selectedValue?.groupID).groupID;
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
                var groupId = await DataLoader().createAndJoinNewGroupByName(_groupNameInputController.text);
                if (context.mounted) {
                  context.pop();
                  context.pop();
                }

                if (groupId < 0) {
                  // TODO: 그룹 생성 후 가입 실패 액션
                  return;
                }

                await _dataRefresh(groupId);

                _groupNameInputController.text = "";
              },
              child: const Text("생성하기"),
            ),
          ],
        ),
      );
}
