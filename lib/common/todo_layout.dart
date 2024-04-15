import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes/tasks/cubit/cubit.dart';
import 'package:notes/tasks/cubit/states.dart';
import 'package:notes/tasks/presentation/pages/archieved_tasks/archieved_tasks_screen.dart';
import 'package:notes/tasks/presentation/pages/done_tasks/done_tasks_screen.dart';
import 'package:notes/tasks/presentation/pages/new_tasks/new_tasks_screen.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/login/presentation/login.dart';
import 'package:notes/common/widgets.dart';

class TodoLayout extends StatefulWidget {

  const TodoLayout({super.key});

  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

class _TodoLayoutState extends State<TodoLayout> {
  CollectionReference notesRef=FirebaseFirestore.instance.collection('notes');
  File? file;
  Reference? refStorage;
  String? imageUrl;
  var imagePicker=ImagePicker();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var dateController = TextEditingController();

  var timeController = TextEditingController();

  int currentIndex = 0;
  List<String> titles = ['Tasks', 'DoneTasks', 'ArchivedTasks'];
  List<Widget> screens=[];
  @override
  void initState() {
     screens = [
      Offstage(offstage: currentIndex != 0, child: const NewTasksScreen()),
      Offstage(offstage: currentIndex != 1, child: DoneTasksScreen()),
      Offstage(offstage: currentIndex != 2, child: ArchivedTasksScreen()),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertFirebaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, states) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(titles[currentIndex]),
              actions:
              [
                IconButton(onPressed: ()async
                {
                  await FirebaseAuth.instance.signOut();
                  navigateAndFinish(context, Login());
                }, icon: const Icon(
                  Icons.exit_to_app_outlined
                ))
              ],
            ),
            body:  Stack(
              children: screens,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    if(refStorage!=null) {
                      await refStorage!.putFile(file!);
                      imageUrl = await refStorage!.getDownloadURL();
                    }
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                        status: 'new',
                        image: imageUrl,
                        userId: FirebaseAuth.instance.currentUser!.uid
                    );
                    if(mounted) {
                      Navigator
                          .of(context)
                          .pop;
                    }
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                  },
                                  label: 'task title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                  },
                                  label: 'task time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2030-12-10'))
                                        .then((value) {
                                      print(DateFormat.yMMMd().format(value!));
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                  },
                                  label: 'task date',
                                  prefix: Icons.calendar_today,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultButtoun(
                                  function: ()
                                  {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context)=>Container(
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children:
                                              [
                                                const Text(
                                                  'Please Choose Image',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()async
                                                  {
                                                    var picked=await imagePicker.pickImage(source: ImageSource.gallery);
                                                    if(picked !=null)
                                                    {
                                                      file=File(picked.path);
                                                      var imageName=basename(picked.path);
                                                      refStorage =FirebaseStorage.instance.ref('images/$imageName');
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(10),
                                                    child: const Row(
                                                      children:
                                                      [
                                                        Icon(
                                                          Icons.photo_outlined,
                                                          size: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text('From Gallery',
                                                        style: TextStyle(fontSize: 20),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()async
                                                  {
                                                    var picked=await imagePicker.pickImage(source: ImageSource.camera);
                                                    if(picked !=null)
                                                    {
                                                      file=File(picked.path);
                                                      var imageName=basename(picked.path);
                                                      refStorage =FirebaseStorage.instance.ref('images/$imageName');
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(10),
                                                    child: const Row(
                                                      children:
                                                      [
                                                        Icon(
                                                          Icons.camera_alt_outlined,
                                                          size: 30,
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text('From Camera',
                                                          style: TextStyle(fontSize: 20),),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                    );
                                  },
                                    text: 'AddImage',
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }

              },

              child: Icon(
                cubit.fabIcon,
              ),
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
        },
      ),
    );
  }



}


