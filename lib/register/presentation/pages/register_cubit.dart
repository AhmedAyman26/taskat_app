import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/register/domain/models/inputs/user_register_input.dart';
import 'package:notes/register/domain/use_cases/user_register_use_case.dart';
import 'package:notes/register/presentation/pages/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  final UserRegisterUseCase _userRegisterUseCase;
  RegisterCubit(this._userRegisterUseCase) : super(RegisterStates());

  static RegisterCubit get(context)=>BlocProvider.of(context);

  void userRegister(UserRegisterInput userRegisterInput) async{
    emit(state.reduce(registerState: RequestStatus.loading));
    try {
      await _userRegisterUseCase.call(userRegisterInput);
      emit(state.reduce(registerState: RequestStatus.success));
    }
     catch (e)
    {
      print("dflkjlsdflsjdfljsdlkfjklsdjfklsdjfsd");
      emit(state.reduce(registerState: RequestStatus.error, errorMessage: e.toString()));
    }
  }}