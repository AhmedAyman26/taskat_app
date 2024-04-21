import 'package:notes/tasks/domain/repository/tasks_repository.dart';

class UpdateTaskStatusUseCase {
  final TasksRepository _taskRepository;

  UpdateTaskStatusUseCase(this._taskRepository);

  Future<void> call(String id, String status) async {
    await _taskRepository.updateTaskStatus(id, status);
  }
}