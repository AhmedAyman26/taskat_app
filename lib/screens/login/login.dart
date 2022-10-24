import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/screens/login/cubit/cubit.dart';
import 'package:notes/screens/login/cubit/states.dart';
import 'package:notes/widgets/widgets.dart';

import '../register/register_screen.dart';
class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoLoginCubit(),
      child: BlocConsumer<TodoLoginCubit, TodoLoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TodoLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: emailController,
                          label: 'email address',
                          prefix: Icons.email,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'You must enter email address';
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          label: 'password',
                          prefix: Icons.lock,
                          type: TextInputType.visiblePassword,
                          isPassword: cubit.isPassword,
                          suffix: cubit.suffix,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'passwoed is too short';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultButtoun(
                          text: 'login',
                          function: () async {
                            if (formKey.currentState!.validate()) {
                              showLoading(context);
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                context: context
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateAndFinish(context, RegisterScreen());
                              },
                              child: Text('RegisterNow'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
