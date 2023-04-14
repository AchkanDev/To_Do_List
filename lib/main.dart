import 'package:flutter/cupertino.dart';
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
            const TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold))),
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
      home: const MyHomePage(title: Text('To Do List')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Text title;

  const MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    final box = Hive.box<Tasks>(openBox);
    final boxPerson = Hive.box<Persons>(openBoxPerson);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditTaskScreen(tasks: Tasks(),)));
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
                          "My Financial Account ",
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
                      child: const MaterialTextField(
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
              child: ValueListenableBuilder<Box<Tasks>>(
                valueListenable: box.listenable(),
                builder: (BuildContext context, box, Widget? child) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: box.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      final task = box.values.toList()[index];
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Person",
                                  style: themData.textTheme.headline6!
                                      .apply(fontSizeFactor: 0.9),
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
                            )
                          ],
                        );
                      } else {
                        return TaskItem(
                          task: task,
                        );
                      }
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
    return Container(
      height: 84,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
            )
          ]),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
              child: MyCheckBox(widget.task.isCompleted , primaryColor)),
          const SizedBox(
            width: 16,
          ),
          Text(widget.task.name,
              style: TextStyle(
                decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
              )),
        ],
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final Color? color;
  final bool isCompleted;

  MyCheckBox(this.isCompleted, [this.color]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: !isCompleted
            ? Border.all(color: secondaryTextColor, width: 2)
            : null,
        color: isCompleted ? color : null,
      ),
      child: isCompleted ? const Icon(CupertinoIcons.checkmark_alt) : null,
    );
  }
}
class PriortyCheckBox extends StatelessWidget {
  final Color? color;
  final bool isCompleted;

  PriortyCheckBox(this.isCompleted, [this.color]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: isCompleted ? const Icon(CupertinoIcons.checkmark_alt) : null,
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
  const EditTaskScreen({Key? key ,required this.tasks}):super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = Tasks();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<Tasks> box = Hive.box<Tasks>(openBox);
              box.add(task);
            }
          },
          label: const Text("Save Changes")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(flex: 1,child: PriorityButton(onTap: (){
                  setState(() {
                    widget.tasks.priority = Priority.low;
                  });
                },title: "Low", color: Colors.cyanAccent)),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1,child: PriorityButton(onTap: (){
                  setState(() {
                    widget.tasks.priority = Priority.medium;
                  });
                },title: "Medium", color: Colors.amberAccent)),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1,child: PriorityButton(onTap:(){
                  setState(() {
                    widget.tasks.priority = Priority.high;
                  });
                },title: "High",color:  Colors.redAccent)),
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

class PriorityButton extends StatefulWidget {
  final GestureTapCallback onTap;
  bool isTrue = false;
  Color color;
  String title ;

   PriorityButton({Key? key, required this.onTap,required this.title,required this.color }):super(key: key);

  @override
  State<PriorityButton> createState() => _PriorityButtonState();
}

class _PriorityButtonState extends State<PriorityButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: secondaryTextColor.withOpacity(0.2) ,width: 1),
      ),
      height: 40,
      child: InkWell(
        onTap: (){
          setState(() {
            widget.isTrue = !widget.isTrue;

          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: const TextStyle(
                  color: primaryTextColor,
                )),
            PriortyCheckBox(widget.isTrue, widget.color),
          ],
        ),
      ),
    );
  }
}
