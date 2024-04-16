import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/repository/tasks_repository.dart';

class GetTasksByStatusUseCase
{
  final TasksRepository taskRepository;

  GetTasksByStatusUseCase(this.taskRepository);

  Future<List<TaskModel>> call(String status) async
  {
    return await taskRepository.getTaskByStatus(status);
  }
}