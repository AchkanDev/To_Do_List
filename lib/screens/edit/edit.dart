import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/repo/Repository.dart';
import 'package:to_do_list/screens/edit/cubit/edittask_screen_cubit.dart';

import '../../data/data.dart';
import '../../main.dart';
import '../../widgets.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EdittaskScreenCubit>().state.tasks.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EdittaskScreenCubit>().onSaveChangesClick();
            Navigator.of(context).pop();
          },
          label: const Text("Save Changes")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            BlocBuilder<EdittaskScreenCubit, EdittaskScreenState>(
              builder: (context, state) {
                final priority = state.tasks.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityButton(
                          onTap: () {
                            context
                                .read<EdittaskScreenCubit>()
                                .changePeriority(Priority.low);
                          },
                          title: "Low",
                          color: Colors.cyanAccent,
                          isSelected: priority == Priority.low,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityButton(
                            onTap: () {
                              context
                                  .read<EdittaskScreenCubit>()
                                  .changePeriority(Priority.medium);
                            },
                            title: "Medium",
                            color: Colors.amberAccent,
                            isSelected: priority == Priority.medium)),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityButton(
                            onTap: () {
                              context
                                  .read<EdittaskScreenCubit>()
                                  .changePeriority(Priority.high);
                            },
                            title: "High",
                            color: Colors.redAccent,
                            isSelected: priority == Priority.high)),
                  ],
                );
              },
            ),
            TextField(
                controller: _controller,
                onChanged: (value) {
                  context.read<EdittaskScreenCubit>().textChange(value);
                },
                decoration: const InputDecoration(
                    labelText: "Enter task",
                    labelStyle: TextStyle(color: primaryTextColor))),
          ],
        ),
      ),
    );
  }
}
