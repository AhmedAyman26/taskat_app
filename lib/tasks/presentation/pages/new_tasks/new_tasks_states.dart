import 'package:equatable/equatable.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

class NewTasksStates extends Equatable {
  final RequestStatus? currentTasksState;
  final List<TaskModel>? currentTasks;
  final RequestStatus? addNewTasksState;
  final RequestStatus? updateTaskStatusState;
  final String ? updatedStatus;
  final String? errorMessage;

  const NewTasksStates({this.currentTasksState=RequestStatus.initial,
    this.currentTasks=const [],
    this.addNewTasksState=RequestStatus.initial,
    this.updateTaskStatusState=RequestStatus.initial,
    this.updatedStatus='',
    this.errorMessage=''});

  NewTasksStates reduce({RequestStatus? currentTasksState,
    List<TaskModel>? currentTasks,
    RequestStatus? addNewTasksState,
    RequestStatus? updateTaskStatusState,
    String ? updatedStatus,
    String? errorMessage}) {
    return NewTasksStates(
        currentTasksState: currentTasksState ?? this.currentTasksState,
        currentTasks: currentTasks ?? this.currentTasks,
        addNewTasksState: addNewTasksState ?? this.addNewTasksState,
        updateTaskStatusState: updateTaskStatusState ?? this.updateTaskStatusState,
        updatedStatus: updatedStatus ?? this.updatedStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [currentTasksState, currentTasks, addNewTasksState, errorMessage, updatedStatus, updateTaskStatusState];
}

