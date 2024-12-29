import 'package:flutter/material.dart';
import 'package:meali/mainscreen/component/memo/checkboxtile.dart';
import 'package:meali/static/font_system.dart';

class MealiContentParser {
  static String memoToString(List<Widget> memo) {
    String s = "";

    return s;
  }

  static (Widget, List<Widget>) stringToMemo(String s) {
    Widget title;
    List<Widget> content = [];

    var split = s.split('\n');
    // title
    title = SizedBox(
      width: double.infinity,
      child: Text(
        split[0],
        style: FontSystem.memoTitle,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
      ),
    );

    // content
    for (var i = 1; i < split.length; ++i) {
      if (split[i].length >= 3 && split[i].substring(0, 3).contains(RegExp('[(o|x)]'))) {
        content.add(CheckBoxTile(
          content: split[i].substring(3),
          checked: split[i][1] == 'o',
        ));
      } else {
        content.add(SizedBox(
          width: double.infinity,
          child: Text(
            split[i],
            style: FontSystem.content14,
          ),
        ));
      }
    }

    return (title, content);
  }
}
