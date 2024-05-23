// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:php_flutter/auth/log_in.dart';
import 'package:php_flutter/auth/widget/app_text_form_field.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/constant/links_api.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  bool isConfirmPasswordObscure = true;
  final Crud _crud = Crud();
  signUp() async {
    var response = await _crud.postRequest(linkSignUp, {
      "userName": nameController.text.toString(),
      "userEmail": emailController.text.toString(),
      "userPass": passwordController.text.toString(),
    });

    if (response != null && response is Map<String, dynamic>) {
      if (response.containsKey("status") && response["status"] == true) {
        // Registration successful
      } else {
        // Registration failed or status not found in response
        log('sign up failed');
      }
    } else {
      // Invalid or null response
      log('Invalid response from server');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.30,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 140, 255),
                      Color.fromARGB(255, 1, 94, 255),
                      Color.fromARGB(255, 1, 35, 255),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'Creat New Account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTextFormField(
                      icon: Icons.person_add_alt_outlined,
                      hintText: 'Username...',
                      isEmail: false,
                      isPassword: false,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleas enter your username';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      icon: Icons.email_outlined,
                      hintText: 'Email...',
                      isEmail: true,
                      isPassword: false,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleas enter your email';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      icon: Icons.lock_outline,
                      hintText: 'Password...',
                      isEmail: false,
                      isPassword: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleas enter your password';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          QuickAlert.show(
                            context: context,
                            backgroundColor: Colors.black12,
                            type: QuickAlertType.confirm,
                            text:
                                'if you prees Okay the proccess it will be done you can login now',
                            textColor: Colors.white,
                            onConfirmBtnTap: () async {
                              await signUp();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (value) => const LoginPage()));
                            },
                            showCancelBtn: false,
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 140, 255),
                              Color.fromARGB(255, 1, 94, 255),
                              Color.fromARGB(255, 1, 35, 255),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: buildRegistrationLink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegistrationLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Have an account?',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const LoginPage()));
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 132, 255),
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
