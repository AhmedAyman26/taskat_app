import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_screen.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/login/presentation/login.dart';
import 'package:notes/common/widgets.dart';

class TodoLayout extends StatefulWidget {
  const TodoLayout({super.key});

  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

class _TodoLayoutState extends State<TodoLayout> {
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
              Offstage(offstage: currentIndex != 0, child: NewTasksPage()),
              // Offstage(offstage: currentIndex != 1, child: DoneTasksScreen()),
              // Offstage(offstage: currentIndex != 2, child: ArchivedTasksScreen()),
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
