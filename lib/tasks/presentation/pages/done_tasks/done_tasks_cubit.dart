import 'package:bloc/bloc.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/use_cases/get_task_by_status_use_case.dart';
import 'package:notes/tasks/domain/use_cases/update_task_status_use_case.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_states.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';

class DoneTasksCubit extends Cubit<DoneTasksStates> {
  late final GetTasksByStatusUseCase _getTasksByStatusUseCase;
  late final UpdateTaskStatusUseCase _updateTaskStatusUseCase;

  DoneTasksCubit()
      : super( const DoneTasksStates())
  {
    _getTasksByStatusUseCase = injector();
    _updateTaskStatusUseCase = injector();
  }

  Future<void> getDoneTasks() async {
    emit(state.reduce(doneTasksState: RequestStatus.loading));
    try {
      final currentTasks = _getTasksByStatusUseCase.call('done');
      emit(state.reduce(
          doneTasksState: RequestStatus.success, doneTasks: await currentTasks));
    } catch (error) {
      emit(state.reduce(
          errorMessage: error.toString(), doneTasksState: RequestStatus.error));
    }
  }
}
