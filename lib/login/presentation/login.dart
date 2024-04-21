import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/presentation/widgets/app_button.dart';
import 'package:notes/common/presentation/widgets/app_text_form_field.dart';
import 'package:notes/login/presentation/cubit/cubit.dart';
import 'package:notes/login/presentation/cubit/states.dart';
import 'package:notes/common/utils.dart';

import '../../register/presentation/pages/register_page.dart';
class Login extends StatefulWidget {
  const Login({super.key});

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
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppTextFormField(
                          controller: emailController,
                          label: 'email address',
                          prefix: const Icon(Icons.email),
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'You must enter email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextFormField(
                          controller: passwordController,
                          label: 'password',
                          prefix: const Icon(Icons.lock),
                          type: TextInputType.visiblePassword,
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
                        const SizedBox(
                          height: 10,
                        ),
                        AppButton(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateAndFinish(context, const RegisterPage());
                              },
                              child: const Text('RegisterNow'),
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
