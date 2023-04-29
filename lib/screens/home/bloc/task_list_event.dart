part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}

class TaskListStarted extends TaskListEvent {}

class TaskListSearched extends TaskListEvent {
  final String search;

  TaskListSearched(this.search);
}

class TaskListDeleteAll extends TaskListEvent {}
