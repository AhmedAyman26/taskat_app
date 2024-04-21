import 'package:flutter/material.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/common/presentation/widgets/app_divider.dart';
import 'package:notes/common/utils/tasks_composition.dart';
import 'package:notes/tasks/presentation/pages/archieved_tasks/archived_tasks_cubit.dart';
import 'package:notes/tasks/presentation/pages/archieved_tasks/archived_tasks_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/presentation/widgets/retry_failed_loading.dart';
import 'package:notes/common/utils.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/presentation/wigdgets/task_item_widget.dart';
import 'package:rxdart/rxdart.dart';

class ArchivedTasksPage extends StatelessWidget {
  const ArchivedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedTasksCubit(),
      child: const ArchivedTasksPageBody(),
    );
  }
}

class ArchivedTasksPageBody extends StatefulWidget {
  const ArchivedTasksPageBody({super.key});

  @override
  State<ArchivedTasksPageBody> createState() => _ArchivedTasksPageBodyState();
}

class _ArchivedTasksPageBodyState extends State<ArchivedTasksPageBody> {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<ArchivedTasksCubit>(context).getArchivedTasks();
    _compositeSubscription
        .add(TasksComposition.changedTaskStatusStream().listen((event) {
      if (event == 'archived') {
        BlocProvider.of<ArchivedTasksCubit>(context).getArchivedTasks();
      }
    }));
    super.initState();
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedTasksCubit, ArchivedTasksStates>(
        builder: (context, state) {
          if (state.archivedTasksState == RequestStatus.error) {
            return RetryFailedLoading(
              onRetryPressed: () {
                BlocProvider.of<ArchivedTasksCubit>(context).getArchivedTasks();
              },
            );
          } else if (state.archivedTasksState == RequestStatus.success) {
            if (state.archivedTasks?.isNotEmpty == true) {
              return Scaffold(
                  key: scaffoldKey,
                  body: ListView.separated(
                    itemBuilder: (context, index) => TaskItem(
                      task: state.archivedTasks?[index]??const TaskModel.initial(),),
                    separatorBuilder: (context, index) => AppDivider(),
                    itemCount: state.archivedTasks?.length ?? 0,
                  ));
            }
            return Center(
              child: Container(
                color: Colors.green,
              ),
            );
          } else if (state.archivedTasksState == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        });
  }
}
