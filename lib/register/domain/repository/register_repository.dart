import 'package:notes/register/domain/models/inputs/user_register_input.dart';

abstract class RegisterRepository {
  Future<void> register(UserRegisterInput userRegisterInput);
}