part of 'edittask_screen_cubit.dart';

@immutable
abstract class EdittaskScreenState {
  final Tasks tasks;

  const EdittaskScreenState(this.tasks);
}

class EdittaskScreenInitial extends EdittaskScreenState {
  const EdittaskScreenInitial(super.tasks);
}

class EditTaskPriorityChange extends EdittaskScreenState {
  const EditTaskPriorityChange(super.tasks);
}
