import 'package:flutter/material.dart';
import 'package:meali/common/user_data.dart';
import 'package:meali/mainscreen/component/memo/checkboxtile.dart';
import 'package:meali/mainscreen/component/userlist/user_info.dart';
import 'package:meali/mainscreen/meali_content_parser.dart';
import 'package:meali/static/color_system.dart';
import 'package:meali/static/font_system.dart';

class Memo extends StatelessWidget {
  /// title of memo
  final String source;
  late final Widget title;
  late final List<Widget>? content;

  /// user data(name, thumbnailUrl)
  final UserData userdata;

  /// edit time
  final DateTime timeStamp;

  final MemoDragOptions? dragOptions;

  Memo({
    super.key,
    required this.source,
    required this.userdata,
    required this.timeStamp,
    this.dragOptions,
  }) {
    var (title, content) = MealiContentParser.stringToMemo(source);
    this.title = title;
    this.content = content;
  }

  String dateFormatter(DateTime timeStamp) {
    var difference = DateTime.now().difference(timeStamp);

    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes.toString()}분 전';
    } else if (difference.inHours < 60) {
      return '${difference.inHours.toString()}시간 전';
    } else {
      return '$difference';
    }
  }

  @override
  Widget build(BuildContext context) {
    var child = Column(
      children: [
        /// [Header]
        title,

        /// [Content]
        content != null
            ? Column(
                children: () {
                  content!.insert(0, const SizedBox(height: 12));
                  return content!;
                }(),
              )
            : const SizedBox.shrink(),

        /// [Bottom]
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [UserInfo.horizontal(userdata: userdata), Text(dateFormatter(timeStamp))],
        ),
      ],
    );
    return dragOptions != null
        ? DraggableMemoContainer(
            dragOptions: dragOptions!,
            child: child,
          )
        : MemoContainer(child: child);
  }
}

class DraggableMemoContainer extends StatelessWidget {
  const DraggableMemoContainer({
    super.key,
    required this.child,
    required this.dragOptions,
  });

  final Widget child;
  final MemoDragOptions dragOptions;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: dragOptions.data,
      dragAnchorStrategy: (draggable, context, position) => Offset((MediaQuery.of(context).size.width - 40) / 2, 0),
      onDragStarted: dragOptions.onDragStarted,
      onDragEnd: dragOptions.onDragEnd,
      feedback: Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
          child: Opacity(opacity: 0.7, child: MemoContainer(child: child)),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: MemoContainer(child: child),
      ),
      child: MemoContainer(child: child),
    );
  }
}

class MemoDragOptions<T> {
  MemoDragOptions({
    required this.onDragStarted,
    required this.onDragEnd,
    required this.data,
  });

  final void Function() onDragStarted;
  final void Function(DraggableDetails details) onDragEnd;
  final T data;
}

class MemoContainer extends StatelessWidget {
  const MemoContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ColorSystem.shadow,
      ),
      child: child,
    );
  }
}
