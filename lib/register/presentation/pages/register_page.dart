import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/common/di/app_injector.dart';
import 'package:notes/common/network/sas.dart';
import 'package:notes/common/presentation/pages/home_page.dart';
import 'package:notes/common/presentation/widgets/app_button.dart';
import 'package:notes/common/presentation/widgets/app_text_form_field.dart';
import 'package:notes/common/utils.dart';
import 'package:notes/register/domain/models/inputs/user_register_input.dart';
import 'package:notes/register/presentation/pages/register_cubit.dart';
import 'package:notes/register/presentation/pages/register_states.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(injector()),
        child: const RegisterPageBody());
  }
}

class RegisterPageBody extends StatefulWidget {
  const RegisterPageBody({super.key});

  @override
  State<RegisterPageBody> createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<RegisterPageBody> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state.registerState == RequestStatus.success) {
          navigateAndFinish(context, const HomePage());
        }
        if(state.registerState == RequestStatus.error){
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body:  Text(state.errorMessage??''),)
            .show();
        }
      },
      builder: (context, state) {
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
                                  .headlineMedium!
                                  .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Register to always list your daily tasks',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AppTextFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'you must enter name';
                                }
                                return null;
                              },
                              label: 'User Name',
                              prefix: const Icon(Icons.person),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppTextFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'you must enter email';
                                }
                              },
                              label: 'Email',
                              prefix: const Icon(Icons.email),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppTextFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              onSubmit: (value) {},
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'password is too short';
                                }
                                return null;
                              },
                              label: 'Password',
                              prefix: const Icon(Icons.lock),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppButton(
                                function: () async {
                                  if (formKey.currentState!.validate()) {
                                    showLoading(context);
                                    RegisterCubit.get(context).userRegister(
                                        UserRegisterInput(nameController.text,
                                            emailController.text,
                                            passwordController.text)
                                    );
                                  }
                                },
                                text: 'REGISTER',
                                background: Colors.green),
                            const SizedBox(
                              height: 15,
                            ),
                          ]),
                    ),
                  ),
                )));
      },
    );
  }
}
