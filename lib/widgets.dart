import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MyCheckBox extends StatelessWidget {
  final bool isCompleted;
  final GestureTapCallback onTap;

  MyCheckBox({required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !isCompleted
              ? Border.all(color: secondaryTextColor, width: 2)
              : null,
          color: isCompleted ? primaryColor : null,
        ),
        child: isCompleted ? const Icon(CupertinoIcons.checkmark_alt) : null,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Icon(CupertinoIcons.book_circle_fill), Text("Task is Empty")],
    );
  }
}

class PriorityButton extends StatelessWidget {
  final GestureTapCallback onTap;
  Color color;
  String title;
  bool isSelected;

  PriorityButton(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.color,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(color: secondaryTextColor.withOpacity(0.2), width: 1),
        ),
        height: 40,
        child: Stack(
          children: [
            Center(
              child: Text(title,
                  style: const TextStyle(
                    color: primaryTextColor,
                  )),
            ),
            Positioned(
              top: 0,
              right: 8,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color,
                  ),
                  child: isSelected
                      ? const Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 12,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
