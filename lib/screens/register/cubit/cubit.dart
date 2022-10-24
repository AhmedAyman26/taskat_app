import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/layout/todo_layout.dart';
import 'package:notes/screens/register/cubit/states.dart';
import 'package:notes/widgets/widgets.dart';

class TodoRegisterCubit extends Cubit<TodoRegisterStates>{
  TodoRegisterCubit() : super(TodoRegisterInitialState());

  static TodoRegisterCubit get(context)=>BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    context,
  })
  {
    emit(TodoRegisterLoadingState());

      FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value)
    {
      navigateAndFinish(context, TodoLayout());
      FirebaseFirestore.instance.collection('users').add(
          {
            'email': email,
            'username': name,
          });
      emit(TodoRegisterSuccesState());
    }).catchError((e)
      {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Password is to weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email"))
            ..show();
        }});

  }

}