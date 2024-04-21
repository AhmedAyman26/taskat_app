import 'package:notes/register/domain/models/inputs/user_register_input.dart';
import 'package:notes/register/domain/repository/register_repository.dart';

class UserRegisterUseCase {
  final RegisterRepository _registerRepository;

  UserRegisterUseCase(this._registerRepository);
  Future<void> call(UserRegisterInput userRegisterInput) async
  {
    await _registerRepository.register(userRegisterInput);
  }
}