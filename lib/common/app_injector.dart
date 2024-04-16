import 'package:get_it/get_it.dart';
import 'package:notes/tasks/di/tasks_di.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  TasksDi.initialize();
}

Future<void> resetScopeDependencies() async {
  await injector.resetScope();
  await initializeDependencies();
}
