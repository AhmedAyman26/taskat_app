import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/common/network/network_info.dart';
import 'package:notes/tasks/data/mappers/firebase_task_mapper.dart';
import 'package:notes/tasks/data/models/firebase_task_model.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/repository/tasks_repository.dart';

class TasksRepositoryImpl extends TasksRepository {
  final NetworkInfoImpl networkInfo;

  final CollectionReference<Map<String, dynamic>> tasksReferences =
      FirebaseFirestore.instance.collection('notes');

  TasksRepositoryImpl(this.networkInfo);

  @override
  Future<List<TaskModel>> getTaskByStatus(String status) async {
    if (!(await networkInfo.isConnected)) {
      throw Exception('No Internet Connection');
    } else {
      List<TaskModel> tasks = [];
      await tasksReferences
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: status)
          .get()
          .then((value) {
        tasks = value.docs
            .map((e) => FirebaseTaskModel.fromJson(e.data())
                .mapToTaskModel()
                .modify(id: e.id))
            .toList();
      }).catchError((error) {
        throw Exception(error.toString());
      });
      return tasks;
    }
  }

  @override
  Future<void> addNewTask(TaskModel task) async {
    tasksReferences.add(task.mapToFirebaseTaskModel().toJson());
  }

  @override
  Future<void> updateTaskStatus(String id, String status) async {
    if (!(await networkInfo.isConnected)) {
      throw Exception('No Internet Connection');
    } else {
      await tasksReferences.doc(id).update({'status': status});
    }
  }
}
