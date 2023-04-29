part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListSuccess extends TaskListState {
  final List<Tasks> task;

  TaskListSuccess(this.task);
}

class TaskListErorr extends TaskListState {
  final String erorrMessage;

  TaskListErorr(this.erorrMessage);
}

class TaskListLoading extends TaskListState {}

class TaskListEmpty extends TaskListState {}
