import 'package:flutter/material.dart';

import '../profile/sub_widgets/MyPasswordFIeld.dart';

// ignore: must_be_immutable
class TaskTextField extends StatelessWidget {
  late TextEditingController _controller = TextEditingController();

  // TextEditingController _controller2;
  Validator validator;
  String text;
  bool enable;
  String helperText;
  String body;
  int lines = 1;

  TaskTextField(this.text, this._controller, this.lines, this.body, this.enable,
      this.validator,
      {this.helperText = "", super.key}) {
    _controller.text = body;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: TextFormField(
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.multiline,
        maxLines: lines,
        enabled: enable,
        onTap: () {},
        validator: validator,
        controller: _controller,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          disabledBorder: getBorders(Colors.blue),
          focusedBorder: getBorders(Colors.green),
          enabledBorder: getBorders(Colors.blue),
          border: getBorders(Colors.blue),
          helperText: helperText,
          labelText: text,
          labelStyle: Theme.of(context).textTheme.headlineSmall,
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
