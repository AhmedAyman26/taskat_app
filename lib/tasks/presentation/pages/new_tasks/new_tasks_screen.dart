import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/add_new_task_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/common/app_injector.dart';
import 'package:notes/common/retry_failed_loading.dart';
import 'package:notes/common/widgets.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_cubit.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_states.dart';

class NewTasksPage extends StatelessWidget {
  const NewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewTasksCubit(injector(), injector()),
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
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: BlocListener<NewTasksCubit, NewTasksStates>(
        listener: (context, state) {
          if (state.addNewTasksState == RequestStatus.success) {
            Navigator.of(context).pop();
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
                  BlocProvider.of<NewTasksCubit>(context).addNewTask(TaskModel(
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
      body: BlocBuilder<NewTasksCubit, NewTasksStates>(
        builder: (context, state) {
          if (state.currentTasksState == RequestStatus.error) {
            return RetryFailedLoading(
              onRetryPressed: () {},
            );
          } else if (state.currentTasksState == RequestStatus.success) {
            if (state.currentTasks?.isNotEmpty == true) {
              return ListView.separated(
                itemBuilder: (context, index) => BuildTaskItem(
                    state.currentTasks?[index] ?? const TaskModel.initial(),
                    context),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: state.currentTasks?.length ?? 0,
              );
            } else {
              return Center(
                child: Container(
                  color: Colors.green,
                ),
              );
            }
          } else if (state.currentTasksState == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
