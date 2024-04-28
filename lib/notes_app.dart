import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/dimensions.dart';
import 'package:notes/common/styles/themes.dart';
import 'package:notes/common/presentation/pages/home_page.dart';
import 'package:notes/login/presentation/login.dart';


class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  bool? isLogin;

  @override
  void initState() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isLogin = false;
    } else {
      isLogin = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.isMobile = MediaQuery.of(context).size.shortestSide < 600;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: isLogin == false ? Login() : const HomePage(),
    );
  }
}
