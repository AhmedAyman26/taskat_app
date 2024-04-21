import 'package:equatable/equatable.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

class ArchivedTasksStates extends Equatable {
  final RequestStatus? archivedTasksState;
  final List<TaskModel>? archivedTasks;
  final RequestStatus? updateTaskStatusState;
  final String? updatedStatus;
  final String? errorMessage;

  const ArchivedTasksStates(
      {this.archivedTasksState = RequestStatus.initial,
      this.archivedTasks = const [],
      this.updateTaskStatusState = RequestStatus.initial,
      this.updatedStatus = '',
      this.errorMessage = ''});

  ArchivedTasksStates reduce(
      {RequestStatus? archivedTasksState,
      List<TaskModel>? archivedTasks,
      RequestStatus? updateTaskStatusState,
      String? updatedStatus,
      String? errorMessage})
  {
    return ArchivedTasksStates(
        archivedTasksState: archivedTasksState ?? this.archivedTasksState,
        archivedTasks: archivedTasks ?? this.archivedTasks,
        updateTaskStatusState: updateTaskStatusState ?? this.updateTaskStatusState,
        updatedStatus: updatedStatus ?? this.updatedStatus,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [archivedTasksState, archivedTasks, updateTaskStatusState, updatedStatus, errorMessage];
}
