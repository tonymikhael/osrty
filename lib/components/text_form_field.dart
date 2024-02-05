import 'package:flutter/material.dart';

class CustomizedTextFormField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  const CustomizedTextFormField({
    required this.hintText,
    this.icon,
    required this.validator,
    required this.onChanged,
    this.keyboardType,
    this.controller,
    this.maxLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
          suffixIcon: Icon(icon),
          hintText: "$hintText",
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
