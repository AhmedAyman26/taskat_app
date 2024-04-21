
import 'package:bloc/bloc.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/use_cases/get_task_by_status_use_case.dart';
import 'package:notes/tasks/domain/use_cases/update_task_status_use_case.dart';
import 'package:notes/tasks/presentation/pages/archieved_tasks/archived_tasks_states.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_states.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';

class ArchivedTasksCubit extends Cubit<ArchivedTasksStates> {
  late final GetTasksByStatusUseCase _getTasksByStatusUseCase;
  late final UpdateTaskStatusUseCase _updateTaskStatusUseCase;

  ArchivedTasksCubit()
      : super(ArchivedTasksStates())
  {
    _getTasksByStatusUseCase = injector();
    _updateTaskStatusUseCase = injector();
  }

  Future<void> getArchivedTasks() async {
    emit(state.reduce(archivedTasksState: RequestStatus.loading));
    try {
      final currentTasks = _getTasksByStatusUseCase.call('archived');
      emit(state.reduce(
          archivedTasksState: RequestStatus.success, archivedTasks: await currentTasks));
    } catch (error) {
      emit(state.reduce(
          errorMessage: error.toString(), archivedTasksState: RequestStatus.error));
    }
  }


  void updateTaskStatus({
    required String status,
    required String id,

  }) async
  {
    emit(state.reduce(updateTaskStatusState: RequestStatus.loading));
    try {
      await _updateTaskStatusUseCase.call(id, status);
      emit(state.reduce(
          updateTaskStatusState: RequestStatus.success, updatedStatus: status));
    }
    catch (error) {
      emit(state.reduce(updateTaskStatusState: RequestStatus.error,
          errorMessage: error.toString()));
    }
  }
}