import 'package:notes/tasks/domain/models/task_model.dart';

abstract class TasksRepository
{
  Future<List<TaskModel>> getTaskByStatus(String status);
  Future<void> addNewTask(TaskModel task);
}