import 'package:flutter/material.dart';

import '../profile/sub_widgets/MyPasswordFIeld.dart';

// ignore: must_be_immutable
class TaskTextField extends StatelessWidget {
  IconData icon;
  TextEditingController _controller;
  Validator validator;
  String text;
  bool enable;
  String helperText;
  int lines=1;

  TaskTextField(this.text, this.lines, this.enable, this._controller,
      this.validator, this.icon,
      {this.helperText = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(3),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.multiline,
        maxLines: lines,
        enabled: enable,
        onTap: () {},
        validator: validator,
        controller: _controller,
        decoration: InputDecoration(
          disabledBorder: getBorders(Colors.blue),
          focusedBorder: getBorders(Colors.green),
          enabledBorder: getBorders(Colors.blue),
          border: getBorders(Colors.blue),
          helperText: helperText,
          labelText: text,
          labelStyle: Theme.of(context).textTheme.headlineSmall,
          prefixIcon: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder getBorders(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color));
  }
}
