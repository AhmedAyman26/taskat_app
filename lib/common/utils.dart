import 'package:flutter/material.dart';

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (Route<dynamic> route) => false,
    );
showLoading(context)
{
  return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: const Text('please wait'),
        content: SizedBox(
          height: 50,
            child: const Center(child: CircularProgressIndicator(),)),
      ),
  );
}