import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/common/network/network_info.dart';
import 'package:notes/register/domain/models/inputs/user_register_input.dart';
import 'package:notes/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl(this.networkInfo);

  @override
  Future<void> register(UserRegisterInput userRegisterInput) async {
    if (!(await networkInfo.isConnected)) {
      throw Exception('No internet connection');
    } else {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userRegisterInput.email,
        password: userRegisterInput.password,
      )
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .add(userRegisterInput.toJson(true));
      }).catchError((error)
      {
        throw Exception(error.toString());
      });
    }
  }
}
