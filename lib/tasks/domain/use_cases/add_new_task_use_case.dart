import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/repository/tasks_repository.dart';

class AddNewTaskUseCase
{
  final TasksRepository _taskRepository;

  AddNewTaskUseCase(this._taskRepository);

  Future<void> call(TaskModel task) async
  {
    await _taskRepository.addNewTask(task);
  }
}