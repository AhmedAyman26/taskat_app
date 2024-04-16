import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String? id;
  final String? userId;
  final String? title;
  final String? date;
  final String? image;
  final String? time;
  final String? status;

  const TaskModel(
      {this.id,
      this.userId,
      this.title,
      this.date,
      this.image,
      this.time,
      this.status});

  const TaskModel.initial()
      : this(
            id: '',
            userId: '',
            title: '',
            date: '',
            image: '',
            time: '',
            status: '');

  TaskModel modify(
      {final String? id,
      final String? userId,
      final String? title,
      final String? date,
      final String? image,
      final String? time,
      final String? status}) {
    return TaskModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        date: date ?? this.date,
        image: image ?? this.image,
        time: time ?? this.time,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [id, userId, title, date, image, time, status];
}
