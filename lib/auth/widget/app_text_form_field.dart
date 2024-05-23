// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    Key? key,
    required this.hintText,
    required this.isPassword,
    required this.isEmail,
    required this.controller,
    this.validator,
    required this.icon,
  }) : super(key: key);
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
      child: TextFormField(
        validator: validator,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          // filled: true,
          // fillColor: Colors.black.withOpacity(.1),
          prefixIcon: Icon(
            icon,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            // color: Colors.black.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}
