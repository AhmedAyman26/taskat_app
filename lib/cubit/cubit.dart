import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/cubit/states.dart';
import 'package:notes/screens/new_tasks/new_tasks_screen.dart';

import '../screens/archieved_tasks/archieved_tasks_screen.dart';
import '../screens/done_tasks/done_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> Screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = ['Tasks', 'DoneTasks', 'ArchivedTasks'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  CollectionReference notesRef=FirebaseFirestore.instance.collection('notes');

  insertToDatabase({
    required String? title,
    required String? time,
    required String? date,
     required String? image,
    required String? userId,
    required String? status,
  }) async
  {
    await notesRef.add(
        {
          'title':title,
          'time':time,
          'date':date,
          'imageurl':image,
          'userId':userId,
          'status':status,
        }).then((value)
    {
      emit(AppInsertFirebaseState());
    }).catchError((error) {
            print('Error when inserting new record${error.toString()}');
          });;
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
  required String status,
  required String id,

}) async
  {

    await FirebaseFirestore.instance.collection('notes').doc(id).update(
        {
          'status':status
        }).then((value)
    {
      emit(AppUpdatetFirebaseState());
    }).then((value){
  emit(AppUpdatetFirebaseState());

  });

  }

  void deleteData({
    required String id,
    required String url
  }) async
  {

    await notesRef.doc(id).delete()
    .then((value)async
    {
      await FirebaseStorage.instance.refFromURL(url).delete();
      emit(AppDeletetFirebaseState());
    });

  }
  bool isDark= false;

  void ChangeTheme({bool? fromShared})
  {
      isDark=!isDark;
      emit(NewsChangeThemeState());
    }

  }


