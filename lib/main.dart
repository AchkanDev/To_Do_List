import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:to_do_list/data.dart';

import 'package:material_text_fields/material_text_fields.dart';

const openBox = "task";
const openBoxPerson = "person";

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TasksAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Tasks>(openBox);
  Hive.registerAdapter(PersonsAdapter());
  await Hive.openBox<Persons>(openBoxPerson);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryVariantColor,
  ));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);
const primaryTextColor = Color(0xff1D2830);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
        textTheme: GoogleFonts.poppinsTextTheme(
             TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold) , caption:TextStyle(fontWeight: FontWeight.w300 , color: Colors.grey.withOpacity(0.5)))),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            iconColor: secondaryTextColor),
        colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryVariant: primaryVariantColor,
            background: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            onPrimary: Colors.white,
            onBackground: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title = "To Do List";


  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    final box = Hive.box<Tasks>(openBox);
    final boxPerson = Hive.box<Persons>(openBoxPerson);
    final TextEditingController controller = TextEditingController();
    final ValueNotifier<String> searchByKeyword = ValueNotifier("");
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditTaskScreen(tasks: Tasks(),)));
          },
          label: const Text("Add New Task")),
      body: SafeArea(
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
                      child:  MaterialTextField(
                        onChanged: (value){
                          searchByKeyword.value = controller.text;
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
                gradient:
                LinearGradient(colors: [primaryColor, primaryVariantColor]),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: searchByKeyword,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<Tasks>>(
                    valueListenable: box.listenable(),
                    builder: (BuildContext context, box, child) {
                      final List<Tasks> items ;
                      if(controller.text.isEmpty){
                        items = box.values.toList();
                      }
                      else{
                        items = box.values.where((element) => element.name.contains(controller.text)).toList();
                      }
                      if(items.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemCount: items.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
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
                                            borderRadius: BorderRadius.circular(
                                                1.5)),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(onPressed: () {
                                    box.clear();
                                  }, child: Row(
                                    children: [
                                      Text("Delete All"),
                                      SizedBox(width: 4,),
                                      Icon(CupertinoIcons.delete_solid , size: 18,),
                                    ],
                                  crossAxisAlignment: CrossAxisAlignment.center),)
                                ],
                              );
                            } else {
                              final Tasks task = items[index - 1];
                              return TaskItem(task: task);
                            }
                          },
                        );
                      }else{return Center(child: Text("Empty"));}
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
      onLongPress: (){
        widget.task.delete();
      },
      onTap: (){
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditTaskScreen(tasks: widget.task)));
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
            MyCheckBox(isCompleted: widget.task.isCompleted , onTap: (){
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
                    decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
                  )),
            ),
            Text("Hold to delete" , style:theme.textTheme.caption?.apply(color: Colors.grey),),
            SizedBox(width: 15,),
            Container(
              height: 84,
              width: 8,
              decoration: BoxDecoration(
                color: colorPriority,
                borderRadius: BorderRadius.only(topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool isCompleted;
  final GestureTapCallback onTap;

  MyCheckBox({required this.isCompleted,required this.onTap});

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


class EditPersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Person"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            const Text("Add new person"),
            const SizedBox(
              width: 5,
            ),
            const Icon(CupertinoIcons.add)
          ],
        ),
        onPressed: () {
          // final person = Persons();
          // person.name = _controller.text;
          // person.isCompleted = false;
          //
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter name"),
            ),
            Container(
              width: 90,
              child: TextField(
                decoration: const InputDecoration(labelText: "Enter price"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class PriorityButton extends StatelessWidget {
  final GestureTapCallback onTap;
  Color color;
  String title;
  bool isSelected;

  PriorityButton(
      {Key? key, required this.onTap, required this.title, required this.color , required this.isSelected })
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: secondaryTextColor.withOpacity(0.2), width: 1),
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
              child: isSelected ? const Icon(CupertinoIcons.checkmark_alt , size: 12,) : null,
            ),
          ),
        ),
        ],
        ),),
    );
  }
}
