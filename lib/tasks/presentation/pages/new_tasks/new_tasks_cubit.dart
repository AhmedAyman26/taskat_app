import 'package:bloc/bloc.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/use_cases/add_new_task_use_case.dart';
import 'package:notes/tasks/domain/use_cases/get_task_by_status_use_case.dart';
import 'package:notes/tasks/domain/use_cases/update_task_status_use_case.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';

class NewTasksCubit extends Cubit<NewTasksStates> {
  late final GetTasksByStatusUseCase _getTasksByStatusUseCase;
  late final AddNewTaskUseCase _addNewTaskUseCase;
  late final UpdateTaskStatusUseCase _updateTaskStatusUseCase;

  NewTasksCubit()
      : super(const NewTasksStates())
  {
    _getTasksByStatusUseCase = injector();
    _addNewTaskUseCase = injector();
    _updateTaskStatusUseCase = injector();
  }

  Future<void> getNewTasks(String status) async {
    emit(state.reduce(currentTasksState: RequestStatus.loading));
    try {
      final currentTasks = _getTasksByStatusUseCase.call(status);
      emit(state.reduce(
          currentTasksState: RequestStatus.success, currentTasks: await currentTasks));
    } catch (error) {
      emit(state.reduce(
          errorMessage: error.toString(), currentTasksState: RequestStatus.error));
    }
  }

  void addNewTask(TaskModel task) async {
    emit(state.reduce(addNewTasksState: RequestStatus.loading));
    try {
      final tasksList = [...?state.currentTasks];
      await _addNewTaskUseCase.call(task);
      tasksList.add(task);
      emit(state.reduce(
          addNewTasksState: RequestStatus.success, currentTasks: tasksList));
      emit(state.reduce(addNewTasksState: RequestStatus.initial));
    }  catch (error) {
      emit(state.reduce(
          addNewTasksState: RequestStatus.error, errorMessage: error.toString()));
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
