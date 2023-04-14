import 'package:hive/hive.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  bool isCompleted = false;
  @HiveField(2)
  Priority priority = Priority.low;


}
@HiveType(typeId: 2)
class Persons extends HiveObject{
  @HiveField(0)
  String name = " ";
  @HiveField(1)
  bool isCompleted = false;
  @HiveField(2)
  double price = 0;

}
@HiveType(typeId: 1)
enum Priority{
 @HiveField(0)
 low,
 @HiveField(1)
 medium,
 @HiveField(2)
 high
}