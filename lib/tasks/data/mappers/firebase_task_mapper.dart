import 'package:notes/tasks/data/models/firebase_task_model.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

extension FirebaseTaskMapper on FirebaseTaskModel {
  TaskModel mapToTaskModel() {
    return TaskModel(
        userId: userId,
        title: title,
        date: date,
        image: image,
        time: time,
        status: status);
  }
}

extension TaskModelMapper on TaskModel {
  FirebaseTaskModel mapToFirebaseTaskModel() {
    return FirebaseTaskModel(
        userId: userId,
        title: title,
        date: date,
        image: image,
        time: time,
        status: status);
  }
}
