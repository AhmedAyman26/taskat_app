import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/widgets.dart';
import 'package:notes/register/presentation/cubit/cubit.dart';
import 'package:notes/register/presentation/cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoRegisterCubit(),
      child: BlocConsumer<TodoRegisterCubit, TodoRegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TodoRegisterCubit.get(context);
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REGISTER',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Register to always list your daily tasks',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              defaultFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'you must enter name';
                                  }
                                },
                                label: 'User Name',
                                prefix: Icons.person,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'you must enter email';
                                  }
                                },
                                label: 'Email',
                                prefix: Icons.email,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                onSubmit: (value) {},
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'password is too short';
                                  }
                                },
                                label: 'Password',
                                prefix: Icons.lock,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              defaultButtoun(
                                  function: () async {
                                    if(formKey.currentState!.validate())
                                    {
                                      showLoading(context);
                                      cubit.userRegister(
                                          context: context,
                                        email: emailController.text,
                                        name: nameController.text,
                                        password: passwordController.text
                                      );
                                    }
                                  },
                                  text: 'REGISTER',
                                  background: Colors.green),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                      ),
                    ),
                  )));
        },
      ),
    );
  }
}
