import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/network_info.dart';
import 'package:notes/tasks/data/repository/tasks_repository_impl.dart';
import 'package:notes/tasks/domain/repository/tasks_repository.dart';
import 'package:notes/tasks/domain/use_cases/add_new_task_use_case.dart';
import 'package:notes/tasks/domain/use_cases/get_task_by_status_use_case.dart';
import 'package:notes/tasks/domain/use_cases/update_task_status_use_case.dart';

class TasksDi
{
  static void initialize()
  {
    injector.registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(NetworkInfoImpl(InternetConnectionChecker())));

    injector.registerFactory(() => GetTasksByStatusUseCase(injector()));
    injector.registerFactory(() => AddNewTaskUseCase(injector()));
    injector.registerFactory(() => UpdateTaskStatusUseCase(injector()));
  }
}