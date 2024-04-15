import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/widgets.dart';
import 'package:notes/tasks/cubit/cubit.dart';
import 'package:notes/tasks/cubit/states.dart';


class NewTasksScreen extends StatefulWidget {


  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  @override
  void initState() {
    print(FirebaseFirestore.instance.collection('notes').get());
    super.initState();
  }
  CollectionReference notesref=FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {

        var tasks=AppCubit.get(context).newTasks;
        print("DSFSDFdsfdfdsfsdf");
        return FutureBuilder(
          future: notesref.where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('status',isEqualTo: 'new').get(),
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
            {
              return ListView.separated(
                itemBuilder: (context,index)=>BuildTaskItem(snapshot.data!.docs[index],context),
                separatorBuilder: (context,index)=>myDivider(),
                itemCount: snapshot.data!.docs.length,
              );
            }else
            {
              return const Center(child: CircularProgressIndicator());
            }
          },
    );
  }
}
