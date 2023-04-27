import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/data.dart';
import '../main.dart';
import '../widgets.dart';

class EditTaskScreen extends StatefulWidget {
  final Tasks tasks;

  const EditTaskScreen({Key? key, required this.tasks}) :super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.tasks.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.tasks.name = _controller.text;
            widget.tasks.priority = widget.tasks.priority;
            if (widget.tasks.isInBox) {
              widget.tasks.save();
            } else {
              final Box<Tasks> box = Hive.box<Tasks>(openBox);
              box.add(widget.tasks);
            }
            Navigator.of(context).pop();
          },
          label: const Text("Save Changes")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(flex: 1, child: PriorityButton(onTap: () {
                  setState(() {
                    widget.tasks.priority = Priority.low;
                  });
                }, title: "Low", color: Colors.cyanAccent , isSelected: widget.tasks.priority == Priority.low,)),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1, child: PriorityButton(onTap: () {
                  setState(() {
                    widget.tasks.priority = Priority.medium;
                  });
                }, title: "Medium", color: Colors.amberAccent, isSelected: widget.tasks.priority == Priority.medium)),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1, child: PriorityButton(onTap: () {
                  setState(() {
                    widget.tasks.priority = Priority.high;
                  });
                }, title: "High", color: Colors.redAccent, isSelected: widget.tasks.priority == Priority.high)),
              ],
            ),
            TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    labelText: "Enter task",
                    labelStyle: TextStyle(color: primaryTextColor))),
          ],
        ),
      ),
    );
  }
}

