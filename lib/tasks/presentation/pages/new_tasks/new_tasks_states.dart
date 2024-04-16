import 'package:equatable/equatable.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

class NewTasksStates extends Equatable {
  final RequestStatus? currentTasksState;
  final List<TaskModel>? currentTasks;
  final RequestStatus? addNewTasksState;
  final String? errorMessage;

  const NewTasksStates(
      {this.currentTasksState,
      this.currentTasks,
      this.addNewTasksState,
      this.errorMessage});

  NewTasksStates reduce(
      {RequestStatus? currentTasksState,
      List<TaskModel>? currentTasks,
      RequestStatus? addNewTasksState,
      String? errorMessage}) {
    return NewTasksStates(
        currentTasksState: currentTasksState ?? this.currentTasksState,
        currentTasks: currentTasks ?? this.currentTasks,
        addNewTasksState: addNewTasksState ?? this.addNewTasksState,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [currentTasksState, currentTasks, addNewTasksState, errorMessage];
}

enum RequestStatus { initial, loading, success, error }
