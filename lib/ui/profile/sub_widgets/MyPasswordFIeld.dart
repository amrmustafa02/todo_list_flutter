import 'package:flutter/material.dart';
typedef Validator = String? Function(String?);
class MyPasswordField extends StatefulWidget {
   TextEditingController _controller;
   Validator validator;

   MyPasswordField(this._controller,this.validator);

  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  bool isPassword = true;

  Icon icon = const Icon(Icons.visibility_off_outlined);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:  widget.validator,
      controller: widget._controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
        prefixIcon: const Icon(Icons.lock),
        prefixIconColor: Colors.black,
        suffixIcon: IconButton(
            onPressed: () {
              if (isPassword) {
                icon = const Icon(Icons.visibility);
              } else if (!isPassword) {
                icon = const Icon(Icons.visibility_off_outlined);
              }
              isPassword = !isPassword;
                setState(() {
                });
            },
            icon: icon),
        suffixIconColor: Colors.black
      ),
    );
  }
}
