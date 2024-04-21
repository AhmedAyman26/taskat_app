import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/common/presentation/widgets/app_divider.dart';
import 'package:notes/common/utils/tasks_composition.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/add_new_task_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/common/presentation/widgets/retry_failed_loading.dart';
import 'package:notes/common/utils.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_cubit.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';
import 'package:notes/tasks/presentation/wigdgets/task_item_widget.dart';

class NewTasksPage extends StatelessWidget {
  const NewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewTasksCubit(),
      child: const NewTasksPageBody(),
    );
  }
}

class NewTasksPageBody extends StatefulWidget {
  const NewTasksPageBody({super.key});

  @override
  State<NewTasksPageBody> createState() => _NewTasksPageBodyState();
}

class _NewTasksPageBodyState extends State<NewTasksPageBody> {
  File? file;
  Reference? refStorage;
  String? imageUrl;
  var imagePicker = ImagePicker();

  final titleController = TextEditingController();

  final dateController = TextEditingController();

  final timeController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;

  @override
  void initState() {
    BlocProvider.of<NewTasksCubit>(context).getNewTasks('new');
    super.initState();
  }

  @override
  void dispose() {
    {
      titleController.dispose();
      dateController.dispose();
      timeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewTasksCubit, NewTasksStates>(
        builder: (context, state) {
      if (state.currentTasksState == RequestStatus.error) {
        return RetryFailedLoading(
          onRetryPressed: () {
            BlocProvider.of<NewTasksCubit>(context).getNewTasks('new');
          },
        );
      } else if (state.currentTasksState == RequestStatus.success) {
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: BlocListener<NewTasksCubit, NewTasksStates>(
            listener: (context, state) {
              if (state.addNewTasksState == RequestStatus.success) {
                Navigator.of(context).pop();
              }
              if (state.updateTaskStatusState == RequestStatus.success) {
                BlocProvider.of<NewTasksCubit>(context).getNewTasks('new');
              }
            },
            child: FloatingActionButton(
              onPressed: () async {
                if (isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    if (refStorage != null) {
                      await refStorage!.putFile(file!);
                      imageUrl = await refStorage!.getDownloadURL();
                    }
                    if (mounted) {
                      BlocProvider.of<NewTasksCubit>(context).addNewTask(
                          TaskModel(
                              title: titleController.text,
                              time: timeController.text,
                              date: dateController.text,
                              status: 'new',
                              image: imageUrl,
                              userId: FirebaseAuth.instance.currentUser!.uid));
                    }
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => AddNewTaskBottomSheet(
                            titleController: titleController,
                            dateController: dateController,
                            timeController: timeController,
                            formKey: formKey),
                      )
                      .closed
                      .then((value) {
                    isBottomSheetShown = false;
                    setState(() {});
                  });
                  isBottomSheetShown = true;
                  setState(() {});
                }
              },
              child: Icon(isBottomSheetShown ? Icons.add : Icons.edit),
            ),
          ),
          body: state.currentTasks?.isNotEmpty == true
              ? ListView.separated(
                  itemBuilder: (context, index) => TaskItem(
                    task:
                        state.currentTasks?[index] ?? const TaskModel.initial(),
                    onTaskDone: () {
                      BlocProvider.of<NewTasksCubit>(context).updateTaskStatus(
                          status: 'done',
                          id: state.currentTasks?[index].id ?? '');
                      TasksComposition.changeTaskStatus(status: 'done');
                    },
                    onTaskArchived: () {
                      BlocProvider.of<NewTasksCubit>(context).updateTaskStatus(
                          status: 'archived',
                          id: state.currentTasks?[index].id ?? '');
                      TasksComposition.changeTaskStatus(status: 'archived');
                    },
                  ),
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: state.currentTasks?.length ?? 0,
                )
              : const Center(
                  child: Text(
                   'No tasks yet, add some',
                  ),
                ),
        );
      } else if (state.currentTasksState == RequestStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const SizedBox.shrink();
    });
  }
}
