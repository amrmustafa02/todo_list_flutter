import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/Utils.dart';
import '../../../profile/sub_widgets/MyTextField.dart';

class ChangePasswordScreen extends StatelessWidget {
  TextEditingController emailText = TextEditingController();
  var formKey = GlobalKey<FormState>();

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 100),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: formKey,
            child: MyTextField("Email", emailText, const Icon(Icons.email),
                (text) {
              return Utils.checkEmail(text!);
            }),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () {
                  // ignore: unrelated_type_equality_checks
                  if (formKey.currentState!.validate == false) {
                    return;
                  }
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailText.text);
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.email),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Send Email"),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
