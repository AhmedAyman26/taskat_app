import 'package:equatable/equatable.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

class DoneTasksStates extends Equatable {
  final RequestStatus? doneTasksState;
  final List<TaskModel>? doneTasks;
  final RequestStatus? updateTaskStatusState;
  final String ? updatedStatus;
  final String? errorMessage;

  const DoneTasksStates({this.doneTasksState=RequestStatus.initial,
    this.doneTasks=const [],
    this.updateTaskStatusState=RequestStatus.initial,
    this.updatedStatus='',
    this.errorMessage=''});

  DoneTasksStates reduce({RequestStatus? doneTasksState,
    List<TaskModel>? doneTasks,
    RequestStatus? updateTaskStatusState,
    String ? updatedStatus,
    String? errorMessage}) {
    return DoneTasksStates(
        doneTasksState: doneTasksState ?? this.doneTasksState,
        doneTasks: doneTasks ?? this.doneTasks,
        updateTaskStatusState: updateTaskStatusState ?? this.updateTaskStatusState,
        updatedStatus: updatedStatus ?? this.updatedStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [doneTasksState, doneTasks, errorMessage, updatedStatus, updateTaskStatusState];
}

