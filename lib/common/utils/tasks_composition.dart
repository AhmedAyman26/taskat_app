import 'package:rxdart/rxdart.dart';

class TasksComposition {
  static final _changedTaskStatus = PublishSubject<String?>();
  TasksComposition._();

  static void changeTaskStatus({String? status}) {
    _changedTaskStatus.add(status);
  }


  static Stream<String?> changedTaskStatusStream() {
    return _changedTaskStatus.stream;
  }
}