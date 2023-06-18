import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget{
  Function function;
  String text;

  ProfileButton(this.text,this.function,{super.key});
  @override
  Widget build(BuildContext context) {
   return ElevatedButton(
        onPressed: () {
          function();
        },
        child: Row(
          children:  [
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward)
          ],
        ));
  }

}