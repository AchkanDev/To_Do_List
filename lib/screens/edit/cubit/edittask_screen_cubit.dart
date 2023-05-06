import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_list/data/repo/Repository.dart';

import '../../../data/data.dart';

part 'edittask_screen_state.dart';

class EdittaskScreenCubit extends Cubit<EdittaskScreenState> {
  final Tasks _tasks;
  final Repository<Tasks> repository;
  EdittaskScreenCubit(this._tasks, this.repository)
      : super(EdittaskScreenInitial(_tasks));

  void onSaveChangesClick() {
    repository.createOrUpdate(_tasks);
  }

  void changePeriority(Priority priority) {
    _tasks.priority = priority;
    emit(EditTaskPriorityChange(_tasks));
  }

  void textChange(String text) {
    _tasks.name = text;
  }
}
