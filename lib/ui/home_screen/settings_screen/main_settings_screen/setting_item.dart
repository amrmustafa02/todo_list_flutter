import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  IconData iconData;
  String text;
  Function fun;

  SettingItem(
      {super.key,
      required this.fun,
      required this.iconData,
      required this.text,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        fun();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 30,
              color: Colors.blueGrey,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
