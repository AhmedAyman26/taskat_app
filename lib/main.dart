import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/layout/todo_layout.dart';
import 'package:notes/screens/login/login.dart';
import 'package:notes/styles/themes.dart';
import 'package:notes/test.dart';


bool isLogin=false;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user =FirebaseAuth.instance.currentUser;
  if(user==null)
  {
    isLogin=false;
  }else
    {
      isLogin=true;
    }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: isLogin==false ?Login() : TodoLayout(),
    );
  }
}


