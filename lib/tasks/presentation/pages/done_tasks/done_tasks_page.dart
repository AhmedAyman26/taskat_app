import 'package:flutter/material.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/common/presentation/widgets/app_divider.dart';
import 'package:notes/common/utils/tasks_composition.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_cubit.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/presentation/widgets/retry_failed_loading.dart';
import 'package:notes/common/utils.dart';
import 'package:notes/tasks/domain/models/task_model.dart';
import 'package:notes/tasks/presentation/wigdgets/task_item_widget.dart';
import 'package:rxdart/rxdart.dart';

class DoneTasksPage extends StatelessWidget {
  const DoneTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoneTasksCubit(),
      child: const DoneTasksPageBody(),
    );
  }
}

class DoneTasksPageBody extends StatefulWidget {
  const DoneTasksPageBody({super.key});

  @override
  State<DoneTasksPageBody> createState() => _DoneTasksPageBodyState();
}

class _DoneTasksPageBodyState extends State<DoneTasksPageBody> {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<DoneTasksCubit>(context).getDoneTasks();
    _compositeSubscription
        .add(TasksComposition.changedTaskStatusStream().listen((event) {
      if (event == 'done') {
        BlocProvider.of<DoneTasksCubit>(context).getDoneTasks();
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
    return BlocBuilder<DoneTasksCubit, DoneTasksStates>(
        builder: (context, state) {
      if (state.doneTasksState == RequestStatus.error) {
        return RetryFailedLoading(
          onRetryPressed: () {
            BlocProvider.of<DoneTasksCubit>(context).getDoneTasks();
          },
        );
      } else if (state.doneTasksState == RequestStatus.success) {
        if (state.doneTasks?.isNotEmpty == true) {
          return Scaffold(
              key: scaffoldKey,
              body: ListView.separated(
                itemBuilder: (context, index) => TaskItem(
                  task: state.doneTasks?[index]??const TaskModel.initial(),),
                separatorBuilder: (context, index) => AppDivider(),
                itemCount: state.doneTasks?.length ?? 0,
              ));
        }
        return Center(
          child: Container(
            color: Colors.green,
          ),
        );
      } else if (state.doneTasksState == RequestStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const SizedBox.shrink();
    });
  }
}
