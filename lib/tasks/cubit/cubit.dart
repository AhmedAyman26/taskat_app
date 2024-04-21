// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes/tasks/cubit/register_states.dart';
// import 'package:notes/tasks/presentation/pages/archieved_tasks/archieved_tasks_page.dart';
// import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_page.dart';
// import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_page.dart';
// import 'package:sqflite/sqflite.dart';
//
//
// class AppCubit extends Cubit<AppStates> {
//   AppCubit() : super(AppInitialStates());
//
//   static AppCubit get(context) => BlocProvider.of(context);
//
//
//
//   late Database database;
//   List<Map> newTasks = [];
//   List<Map> doneTasks = [];
//   List<Map> archivedTasks = [];
//
//
//
//   CollectionReference notesRef=FirebaseFirestore.instance.collection('notes');
//
//   insertToDatabase({
//     required String? title,
//     required String? time,
//     required String? date,
//      required String? image,
//     required String? userId,
//     required String? status,
//   }) async
//   {
//     await notesRef.add(
//         {
//           'title':title,
//           'time':time,
//           'date':date,
//           'imageurl':image,
//           'userId':userId,
//           'status':status,
//         }).then((value)
//     {
//       emit(AppInsertFirebaseState());
//     }).catchError((error) {
//             print('Error when inserting new record${error.toString()}');
//           });;
//   }
//
//
//   bool isBottomSheetShown = false;
//   IconData fabIcon = Icons.edit;
//
//   void changeBottomSheetState({
//     required bool isShown,
//     required IconData icon,
//   }) {
//     isBottomSheetShown = isShown;
//     fabIcon = icon;
//     emit(AppChangeBottomSheetState());
//   }


//
//   void deleteData({
//     required String id,
//     required String url
//   }) async
//   {
//
//     await notesRef.doc(id).delete()
//     .then((value)async
//     {
//       await FirebaseStorage.instance.refFromURL(url).delete();
//       emit(AppDeletetFirebaseState());
//     });
//
//   }
//   bool isDark= false;
//
//   void ChangeTheme({bool? fromShared})
//   {
//       isDark=!isDark;
//       emit(NewsChangeThemeState());
//     }
//
//   }
//
//
