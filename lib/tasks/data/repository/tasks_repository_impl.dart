import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/tasks/data/mappers/firebase_task_mapper.dart';
import 'package:notes/tasks/data/models/firebase_task_model.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/domain/repository/tasks_repository.dart';

class TasksRepositoryImpl extends TasksRepository {
  final CollectionReference<Map<String, dynamic>> notesRef =
      FirebaseFirestore.instance.collection('notes');

  @override
  Future<List<TaskModel>> getTaskByStatus(String status) async {
    List<TaskModel> tasks = [];
    final result = await notesRef
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: status)
        .get();
    tasks = result.docs
        .map((e) => FirebaseTaskModel.fromJson(e.data())
            .mapToTaskModel()
            .modify(id: e.id))
        .toList();
    return tasks;
  }

  @override
  Future<void> addNewTask(TaskModel task) async {
    notesRef.add(task.mapToFirebaseTaskModel().toJson());
  }
}
