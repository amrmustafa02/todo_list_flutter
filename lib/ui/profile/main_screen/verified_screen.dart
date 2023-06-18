import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/models/my_user.dart';

import '../../../database/MyDataBase.dart';
import '../../../database/user_utils.dart';
import 'login_in.dart';

// ignore: must_be_immutable
class VerifiedScreen extends StatefulWidget {
  MyUser myUser;
  String email;
  String password;
  UserCredential credential;

  static String routeName = "verified_screen";

  VerifiedScreen(this.credential, this.myUser, this.email, this.password,
      {super.key});

  @override
  State<VerifiedScreen> createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  MyDataBase base = MyDataBase.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {

              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/gmail.png",
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const Text(
              "Verify your email address",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            getText("We have just send email verification link on "),
            getText("your email. Please check email and click on"),
            getText("that link to verify your Email address"),
            const SizedBox(
              height: 10,
            ),
            getText("If not auto redirected after verification, click "),
            getText("on the Continue button."),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  clickOnContinue();
                },
                style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.transparent,
                    shadowColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 0,
                    backgroundColor: Colors.transparent),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: () {
                  resendEmail();
                },
                child: const Text("Resend E-mail link")),
          ],
        ),
      ),
    );
  }

  clickOnContinue() async {
    Utils.showLoadingDialog(context);
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
      await base.addUser(widget.myUser);
      //save login info
      await UserDataUtils().autoLogin(widget.email, widget.password);
      gotToLogin();
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Utils.showAlertDialog(context,(){
        Navigator.pop(context);
      }, "Email still not verified");
    }
  }

  gotToLogin() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(context, LogInScreen.routeName, (route) => false);
    });
  }

  resendEmail() async {
    var user2 = FirebaseAuth.instance.currentUser;
    await user2!.sendEmailVerification();
  }

  getText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
