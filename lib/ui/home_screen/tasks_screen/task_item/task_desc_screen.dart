import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDesc extends StatelessWidget {
  String text;

  TaskDesc({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(AppLocalizations.of(context)!.desc,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 24
            ),),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              text,
              style:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
