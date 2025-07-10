import 'package:donate_me_app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextInputField extends StatelessWidget {
  final String name;
  final TextInputType keyboard;
  final String? value;
  final String labelText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const TextInputField({
    super.key,
    required this.name,
    required this.keyboard,
    required this.labelText,
    this.suffixIcon,
    this.value,
    this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      style: const TextStyle(color: Colors.black, fontSize: 14),
      initialValue: value,
      keyboardType: keyboard,
      cursorColor: Colors.black,
      name: name,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          color: kPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
