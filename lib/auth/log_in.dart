// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:php_flutter/auth/sign_up.dart';
import 'package:php_flutter/auth/widget/app_text_form_field.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/main.dart';
import 'package:php_flutter/screen/home/home_page.dart';
import 'package:quickalert/quickalert.dart';
import 'package:php_flutter/constant/links_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Crud _crud = Crud();

  Future<void> logIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await _crud.postRequest(linkLogIn, {
          "userName": emailController.text,
          "userPass": passwordController.text,
        });

        if (response != null && response is Map<String, dynamic>) {
          if (response.containsKey("status") && response["status"] == true) {
            // Registration successful
            sharedPref.setString("id", response['data']['userId'].toString());
            sharedPref.setString(
                "userName", response['data']['userName'].toString());
            sharedPref.setString(
                "userEmail", response['data']['userEmail'].toString());

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (value) => const HomePage()));
          } else {
            // Registration failed or status not found in response
            QuickAlert.show(
              backgroundColor: Colors.black12,
              context: context,
              type: QuickAlertType.error,
              title: 'Username or password is incorrect.',
            );

            log('Login failed');
          }
        } else {
          // Invalid or null response
          log('Invalid response from server');
        }
      } catch (e) {
        log('Error during login: $e');
        QuickAlert.show(
          backgroundColor: Colors.black12,
          context: context,
          type: QuickAlertType.error,
          title: 'An error occurred during login. Please try again later.',
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: size.height * 0.1),
                        Text(
                          'Sign in to your Account',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Sign in to your Account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextFormField(
                          hintText: 'User name...',
                          isEmail: true,
                          isPassword: false,
                          icon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          controller: emailController,
                        ),
                        AppTextFormField(
                          icon: Icons.lock_outline,
                          hintText: 'Password...',
                          isEmail: false,
                          isPassword: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, bottom: 24),
                              child: InkWell(
                                onTap: () async {},
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Forgot password?',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 140, 255),
                                    ),
                                    recognizer: TapGestureRecognizer(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: logIn,
                          child: Container(
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
                                'Login',
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
                  buildRegistrationLink()
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Expanded signInWays(Size size, String data, String image) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: size.width / 8,
          width: size.width / 1.25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Image.asset(
                image,
                width: 22,
                //height: 20,
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
          'Create an account?',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return const RegisterPage();
            }));
          },
          child: const Text(
            'Register',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 141, 255),
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
