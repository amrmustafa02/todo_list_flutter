import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';

class LanguageItem extends StatelessWidget {
  String text;
  String lang;

  LanguageItem({super.key, required this.text, required this.lang});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    return InkWell(
        onTap: () {
          provider.updateLocal(lang);
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
