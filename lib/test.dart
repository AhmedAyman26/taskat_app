import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  File? file;
  var imagePicker = ImagePicker();
  uploadImage()async
  {
    var imagePicked=await imagePicker.getImage(source: ImageSource.camera);
    if(imagePicked!=null)
    {
      file=File(imagePicked.path);
      var imageName=basename(imagePicked.path);

      var refStorage =FirebaseStorage.instance.ref('images/$imageName');
      await refStorage.putFile(file!);
      var url=await refStorage.getDownloadURL();
      print('url: $url');
  }
    else
    {
      print('choose image');
    }
    }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Center(
            child: ElevatedButton(
              onPressed: ()async
              {
                await uploadImage();
              },
              child: Text('UploadImage'),
            ),
          ),
        ],
      ),
    );
  }
}
