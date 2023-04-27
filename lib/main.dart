import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/Repository.dart';
import 'package:to_do_list/data/source/hive_task_source.dart';
import 'package:to_do_list/screens/home/home.dart';

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
  runApp(ChangeNotifierProvider<Repository<Tasks>>(create: (context) =>
    Repository<Tasks>(HiveTaskSource(Hive.box(openBox))),
    child: const MyApp()));
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
        textTheme: GoogleFonts.poppinsTextTheme(TextTheme(
            headline6: TextStyle(fontWeight: FontWeight.bold),
            caption: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey.withOpacity(0.5)))),
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

// class EditPersonScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _controller = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Person"),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         label: Row(
//           children: [
//             const Text("Add new person"),
//             const SizedBox(
//               width: 5,
//             ),
//             const Icon(CupertinoIcons.add)
//           ],
//         ),
//         onPressed: () {
//           // final person = Persons();
//           // person.name = _controller.text;
//           // person.isCompleted = false;
//           //
//         },
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: const InputDecoration(labelText: "Enter name"),
//             ),
//             Container(
//               width: 90,
//               child: TextField(
//                 decoration: const InputDecoration(labelText: "Enter price"),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
