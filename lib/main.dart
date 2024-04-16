import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/app_injector.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/notes_app.dart';

bool isLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "notes", options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const NotesApp());
}

