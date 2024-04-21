import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/network_info.dart';
import 'package:notes/register/data/repository/register_repository_impl.dart';
import 'package:notes/register/domain/repository/register_repository.dart';
import 'package:notes/register/domain/use_cases/user_register_use_case.dart';

class RegisterDi {
  RegisterDi._();

  static void initialize()
  {
    injector.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl(NetworkInfoImpl(InternetConnectionChecker())));

    injector.registerFactory(() => UserRegisterUseCase(injector()));
  }
}