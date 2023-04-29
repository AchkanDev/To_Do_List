import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/Repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<Tasks> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      final String search;
      if (event is TaskListSearched || event is TaskListStarted) {
        if (event is TaskListSearched) {
          search = event.search;
        } else {
          search = "";
        }
        final items = await repository.getAll(serachKeyWord: search);

        if (items.isNotEmpty) {
          emit(TaskListSuccess(items));
        } else {
          emit(TaskListEmpty());
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
