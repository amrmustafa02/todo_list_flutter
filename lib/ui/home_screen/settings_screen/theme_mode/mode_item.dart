import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';

// ignore: must_be_immutable
class ModeItem extends StatelessWidget {
  String text;
  int mode;

  ModeItem({super.key, required this.text, required this.mode});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    return InkWell(
        onTap: () {
          provider.changeMode(mode);
          Future.delayed(const Duration(milliseconds: 250),() {
            Navigator.of(context).pop();

          },);
        },
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(30),
            child: Text(text)));
  }
}
