import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/common/widgets.dart';

class AddNewTaskBottomSheet extends StatefulWidget {
  final TextEditingController titleController;

  final TextEditingController dateController;

  final TextEditingController timeController;

  final GlobalKey formKey;

  const AddNewTaskBottomSheet(
      {super.key,
      required this.titleController,
      required this.dateController,
      required this.timeController,
      required this.formKey});

  @override
  State<AddNewTaskBottomSheet> createState() => _AddNewTaskBottomSheetState();
}

class _AddNewTaskBottomSheetState extends State<AddNewTaskBottomSheet> {
  File? file;
  Reference? refStorage;
  String? imageUrl;
  var imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultFormField(
              controller: widget.titleController,
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
              controller: widget.timeController,
              type: TextInputType.datetime,
              onTap: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((value) {
                  widget.timeController.text =
                      value!.format(context).toString();
                  setState(() {

                  });
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
              controller: widget.dateController,
              type: TextInputType.datetime,
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2030-12-10'))
                    .then((value) {
                  widget.dateController.text =
                      DateFormat.yMMMd().format(value!);
                  setState(() {
                  });

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
            defaultButton(
              function: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Please Choose Image',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () async {
                              var picked = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              if (picked != null) {
                                file = File(picked.path);
                                var imageName = path.basename(picked.path);
                                refStorage = FirebaseStorage.instance
                                    .ref('images/$imageName');
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.photo_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'From Gallery',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var picked = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (picked != null) {
                                file = File(picked.path);
                                var imageName = path.basename(picked.path);
                                refStorage = FirebaseStorage.instance
                                    .ref('images/$imageName');
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'From Camera',
                                    style: TextStyle(fontSize: 20),
                                  ),
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
    );
  }
}
