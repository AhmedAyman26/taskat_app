import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/cubit/cubit.dart';

Widget defaultButtoun({
  double width = double.infinity,
  Color background = Colors.greenAccent,
  bool isUpperCase = true,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onChange,
  Function()? onTap,
  required validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isPassword = false,
  ValueChanged<String>? onSubmit,
}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(
            suffix,
          ),
          onPressed: () {
            suffixPressed!();
          },
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );
Widget BuildTaskItem(QueryDocumentSnapshot note, context) => Dismissible(
  key:UniqueKey(),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 70,
          height: 50,
          child: Image(
            image: NetworkImage(
              '${note['imageurl']}'
            ),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${note['title']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${note['date']}',
                style: TextStyle(color: Colors.grey[300]),
              ),
              Text(
                '${note['time']}',
                style: TextStyle(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateData(
              status: 'done',
              id: note.id,
            );
          },
          icon: Icon(
            Icons.check_box,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateData(
              status: 'archived',
              id: note.id
            );
          },
          icon: Icon(
            Icons.archive,
            color: Colors.black45,
          ),
        ),
      ],
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(id: note.id,url: note['imageurl']);
  },
);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey,
  ),
);

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
        title: Text('please wait'),
        content: Container(
          height: 50,
            child: Center(child: CircularProgressIndicator(),)),
      ),
  );
}