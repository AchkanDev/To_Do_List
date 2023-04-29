import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/repo/Repository.dart';
import 'package:to_do_list/screens/home/bloc/task_list_bloc.dart';

import '../../data/data.dart';
import '../../main.dart';
import '../../widgets.dart';
import '../edit/edit.dart';

class MyHomePage extends StatelessWidget {
  final String title = "To Do List";

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    final TextEditingController controller = TextEditingController();
    final ValueNotifier<String> searchByKeyword = ValueNotifier("");
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                      tasks: Tasks(),
                    )));
          },
          label: const Text("Add New Task")),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Tasks>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To Do List",
                            style: themData.textTheme.headline6!
                                .apply(color: themData.colorScheme.onPrimary),
                          ),
                          Icon(CupertinoIcons.share,
                              color: themData.colorScheme.onPrimary),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        height: 38,
                        // color: themData.colorScheme.onPrimary,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ]),
                        child: MaterialTextField(
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TaskListSearched(controller.text));
                          },
                          controller: controller,
                          prefixIcon: Icon(CupertinoIcons.search),
                          labelText: "Search",
                        ),
                      )
                    ],
                  ),
                ),
                height: 110,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryColor, primaryVariantColor]),
                ),
              ),
              Expanded(
                child: Consumer<Repository<Tasks>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.task, themData: themData);
                        } else if (state is TaskListEmpty) {
                          return EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListErorr) {
                          return Center(
                            child: Text(state.erorrMessage),
                          );
                        } else {
                          throw Exception("State is not valid ..");
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  List<Tasks> items;
  final themData;
  TaskList({required this.items, required this.themData});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Person",
                        style: themData.textTheme.headline6!
                            .apply(fontSizeFactor: 0.9),
                      ),
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 3,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(1.5)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
                },
                child: Row(children: [
                  Text("Delete All"),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    CupertinoIcons.delete_solid,
                    size: 18,
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.center),
              )
            ],
          );
        } else {
          final Tasks task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({required this.task});

  final Tasks task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color colorPriority;
    switch (widget.task.priority) {
      case Priority.high:
        colorPriority = Colors.redAccent;
        break;

      case Priority.medium:
        colorPriority = Colors.yellowAccent;
        break;

      case Priority.low:
        colorPriority = Colors.cyanAccent;
        break;
    }
    return InkWell(
      onLongPress: () {
        final repo = Provider.of<Repository<Tasks>>(context, listen: false);
        repo.delete(widget.task);
      },
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(tasks: widget.task)));
        });
      },
      child: Container(
        height: 84,
        padding: const EdgeInsets.only(left: 16),
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
              )
            ]),
        child: Row(
          children: [
            MyCheckBox(
                isCompleted: widget.task.isCompleted,
                onTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                }),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(widget.task.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  )),
            ),
            Text(
              "Hold to delete",
              style: theme.textTheme.caption?.apply(color: Colors.grey),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 84,
              width: 8,
              decoration: BoxDecoration(
                color: colorPriority,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
