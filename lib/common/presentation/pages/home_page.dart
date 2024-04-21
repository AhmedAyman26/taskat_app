import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/tasks/presentation/pages/archieved_tasks/archieved_tasks_page.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_page.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/login/presentation/login.dart';
import 'package:notes/common/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');
  File? file;


  int currentIndex = 0;
  List<String> titles = ['Tasks', 'DoneTasks', 'ArchivedTasks'];

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(titles[currentIndex]),
            actions: [
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    navigateAndFinish(context, Login());
                  },
                  icon: const Icon(Icons.exit_to_app_outlined))
            ],
          ),
          body: Stack(
            children:[
              Offstage(offstage: currentIndex != 0, child: const NewTasksPage()),
              Offstage(offstage: currentIndex != 1, child: const DoneTasksPage()),
              Offstage(offstage: currentIndex != 2, child: const ArchivedTasksPage()),
            ]
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
              setState(() {});

            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived'),
            ],
          ),
    );
  }
}
