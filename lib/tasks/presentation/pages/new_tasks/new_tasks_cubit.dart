import 'package:bloc/bloc.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/use_cases/add_new_task_use_case.dart';
import 'package:notes/tasks/domain/use_cases/get_task_by_status_use_case.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';

class NewTasksCubit extends Cubit<NewTasksStates> {
  final GetTasksByStatusUseCase _getTasksByStatusUseCase;
  final AddNewTaskUseCase _addNewTaskUseCase;

  NewTasksCubit(this._getTasksByStatusUseCase, this._addNewTaskUseCase)
      : super(const NewTasksStates(currentTasksState: RequestStatus.initial));

  Future<void> getNewTasks(String status) async {
    emit(state.reduce(currentTasksState: RequestStatus.loading));
    try {
      final currentTasks = _getTasksByStatusUseCase.call(status);
      emit(state.reduce(
          currentTasksState: RequestStatus.success, currentTasks: await currentTasks));
    }  catch (error) {
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
    }  catch (error) {
      emit(state.reduce(
          addNewTasksState: RequestStatus.error, errorMessage: error.toString()));
    }
  }
}
