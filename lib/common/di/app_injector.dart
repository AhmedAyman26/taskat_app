import 'package:get_it/get_it.dart';
import 'package:notes/register/di/register_di.dart';
import 'package:notes/tasks/di/tasks_di.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  TasksDi.initialize();
  RegisterDi.initialize();
}

Future<void> resetScopeDependencies() async {
  await injector.resetScope();
  await initializeDependencies();
}
