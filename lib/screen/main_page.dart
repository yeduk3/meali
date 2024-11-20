import 'package:flutter/material.dart';
import 'package:meali/component/memo.dart';
import 'package:meali/component/user_image.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';
import 'package:meali/component/customdropdown.dart' as customdropdown;
import 'package:meali/component/user_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.groups,
    required this.username,
    required this.imageURL,
  });

  final List<String> groups;
  final String username;
  final String imageURL;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedValue = "전체";

  @override
  Widget build(BuildContext context) {
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
                  name: widget.username,
                  imageURL: widget.imageURL,
                  style: FontSystem.nameme12,
                  isNetwork: true,
                ),
                const SizedBox(
                  width: 15,
                ),
                const UserInfo.vertical(
                  name: "이용규",
                  imageURL: "assets/images/test_user_image.jpeg",
                  style: FontSystem.nameother12,
                ),
                const SizedBox(
                  width: 15,
                ),
                const UserInfo.vertical(
                  name: "메아리",
                  imageURL: "assets/images/test_user_image.jpeg",
                  style: FontSystem.nameother12,
                ),

                /// [User Add Button] Last space is 12
                const SizedBox(
                  width: 12,
                ),
                const UserAddButton(),
              ],
            ),
          ),

          /// [Memo List with ReorderableListView]
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {},
                children: [
                  Memo(
                    key: const ValueKey(1),
                    title: "오늘 저녁 메뉴 돼지고기김치찌개임. 반박시 너 말 아님.",
                    imageURL: "assets/images/test_user_image.jpeg",
                    name: "test",
                    timeStamp: DateTime.now(),
                    content: true,
                  ),
                  Memo(
                    key: const ValueKey(2),
                    title: "오늘 저녁 메뉴 돼지고기김치찌개임. 반박시 너 말 아님.",
                    imageURL: "assets/images/test_user_image.jpeg",
                    name: "test",
                    timeStamp: DateTime.now(),
                    content: true,
                  ),
                  Memo(
                    key: const ValueKey(3),
                    title: "오늘 저녁 메뉴 돼지고기김치찌개임. 반박시 너 말 아님.",
                    imageURL: "assets/images/test_user_image.jpeg",
                    name: "test",
                    timeStamp: DateTime.now(),
                    content: true,
                  ),
                  Memo(
                    key: const ValueKey(4),
                    title: "오늘 저녁 메뉴 돼지고기김치찌개임. 반박시 너 말 아님.",
                    imageURL: "assets/images/test_user_image.jpeg",
                    name: "test",
                    timeStamp: DateTime.now(),
                    content: false,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar mealiAppBar() {
    return AppBar(
      toolbarHeight: 54,
      title: customdropdown.DropdownButton<String>(
        value: selectedValue,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 0,
        isExpanded: true,
        style: FontSystem.title,
        underline: const SizedBox(),
        dropdownColor: ColorSystem.white,
        icon: const SizedBox.shrink(),
        selectedItemBuilder:
            _appBarSelectedItemBuilder, // when selected, auto callback
        items: _appBarDropdownMenuItemBuilder(),
        onChanged: (String? value) {
          setState(() {
            selectedValue = value!;
          });
        },
      ),
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

  List<customdropdown.DropdownMenuItem<String>>
      _appBarDropdownMenuItemBuilder() {
    return widget.groups.map<customdropdown.DropdownMenuItem<String>>(
      (e) {
        return customdropdown.DropdownMenuItem<String>(
          value: e,
          child: Text(
            e,
            style: const TextStyle(color: ColorSystem.black),
          ),
        );
      },
    ).toList();
  }

  List<Widget> _appBarSelectedItemBuilder(context) {
    return widget.groups.map<Widget>(
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
              decoration: const BoxDecoration(
                  color: ColorSystem.gray09,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/users_icon.png",
                    width: 12,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "4",
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
