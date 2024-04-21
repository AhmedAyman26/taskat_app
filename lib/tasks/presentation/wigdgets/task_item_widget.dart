import 'package:flutter/material.dart';
import 'package:notes/tasks/domain/models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final void Function()? onTaskDone;
  final void Function()? onTaskArchived;
  const TaskItem({super.key, required this.task,  this.onTaskDone,  this.onTaskArchived});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 50,
              child: Image(
                image: NetworkImage(
                    '${task.image}'
                ),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.title}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${task.date}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  Text(
                    '${task.time}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            task.status!='done'?Row(
              children: [
                IconButton(
                  onPressed: onTaskDone,
                  icon: const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: onTaskArchived,
                  icon: const Icon(
                    Icons.archive,
                    color: Colors.black45,
                  ),
                ),
              ],
            ):SizedBox(),
          ],
        ),
      ),
      onDismissed: (direction) {
        // AppCubit.get(context).deleteData(id: task.id??'',url: task.image??'');
      },
    );
  }
}
