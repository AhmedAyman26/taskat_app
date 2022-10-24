import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/cubit/cubit.dart';
import 'package:notes/cubit/states.dart';
import 'package:notes/screens/login/login.dart';
import 'package:notes/widgets/widgets.dart';

class TodoLayout extends StatefulWidget {

  TodoLayout({super.key});

  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

class _TodoLayoutState extends State<TodoLayout> {
  CollectionReference notesRef=FirebaseFirestore.instance.collection('notes');
  File? file;
  Reference? refSotrage;
  var imagePicker=ImagePicker();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var dateController = TextEditingController();

  var timeController = TextEditingController();

  getUser()
  {
    var user =FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  @override
  void initState() {
    getUser();
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
              title: Text(cubit.title[cubit.currentIndex]),
              actions:
              [
                IconButton(onPressed: ()async
                {
                  await FirebaseAuth.instance.signOut();
                  navigateAndFinish(context, Login());
                }, icon: Icon(
                  Icons.exit_to_app_outlined
                ))
              ],
            ),
            body: cubit.Screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    await refSotrage!.putFile(file!);
                    var imageurl=await refSotrage!.getDownloadURL();
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                        status: 'new',
                        image: imageurl,
                        userId: FirebaseAuth.instance.currentUser!.uid
                    );
                    Navigator.of(context).pop;
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
                                                DateTime.parse('2022-12-10'))
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
                                          padding: EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children:
                                              [
                                                Text(
                                                  'Please Choose Image',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()async
                                                  {
                                                    var picked=await imagePicker.getImage(source: ImageSource.gallery);
                                                    if(picked !=null)
                                                    {
                                                      file=File(picked.path);
                                                      var imageName=basename(picked.path);
                                                      refSotrage =FirebaseStorage.instance.ref('images/$imageName');
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
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
                                                    var picked=await imagePicker.getImage(source: ImageSource.camera);
                                                    if(picked !=null)
                                                    {
                                                      file=File(picked.path);
                                                      var imageName=basename(picked.path);
                                                      refSotrage =FirebaseStorage.instance.ref('images/$imageName');
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
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
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'),
                const BottomNavigationBarItem(
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

  Future<String> getName() async {
    return 'AhmedAyman';
  }

}
