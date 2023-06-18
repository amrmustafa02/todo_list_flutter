import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class MyTextField extends StatelessWidget {
  TextEditingController _controller;
  Validator validator;
  String text;
  Icon icon;

  MyTextField(this.text, this._controller, this.icon, this.validator,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: _controller,
      decoration: InputDecoration(
          prefixIcon: icon,
          prefixIconColor: Colors.black,
          labelText: text,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 14)),
    );
  }
}
