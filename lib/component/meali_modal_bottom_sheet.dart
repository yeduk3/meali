import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';

Null Function() showMealiModalBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  return () {
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
                child,
              ],
            ),
          ),
        ],
      ),
    );
  };
}
