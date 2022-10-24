import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/cubit.dart';
import 'package:notes/cubit/states.dart';
import 'package:notes/widgets/widgets.dart';

class ArchivedTasksScreen extends StatelessWidget {

  CollectionReference notesref=FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        //var tasks=AppCubit.get(context).archivedTasks;
        return FutureBuilder(
          future: notesref.where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('status',isEqualTo: 'archived').get(),
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
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );

  }
}
