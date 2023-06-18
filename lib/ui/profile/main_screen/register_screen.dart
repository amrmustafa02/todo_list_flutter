// ignore: must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/database/MyDataBase.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/models/my_user.dart';
import 'package:to_do/ui/profile/sub_widgets/MyPasswordFIeld.dart';
import 'package:to_do/ui/profile/sub_widgets/MyTextField.dart';
import 'package:to_do/ui/profile/sub_widgets/profile_button.dart';
import 'package:to_do/ui/profile/main_screen/verified_screen.dart';
import 'package:to_do/ui/splash_screen.dart';

import '../../../controllers/Utils.dart';
import 'login_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "sign_up_screen";

  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController fullNameText = TextEditingController();
  var forKey = GlobalKey<FormState>();
  MyDataBase base = MyDataBase.getInstance();
  Utils ctrl = Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/bg_login.png"))),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Sign up",
            style: TextStyle(fontSize: 24),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: forKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField("Full Name", fullNameText,
                        const Icon(Icons.text_format_rounded, size: 30),
                        (text) {
                      if (text!.isEmpty) {
                        return "please enter your name";
                      }
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField("Email", emailText, const Icon(Icons.email),
                        (text) {
                      return Utils.checkEmail(text!);
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    MyPasswordField(passwordText, (text) {
                      return Utils.checkPassword(text!);
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 55,
                      child: ProfileButton("Sign up", signUp),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, LogInScreen.routeName);
                            },
                            child: const Text("Login"))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (forKey.currentState!.validate() == false) {
      return;
    }


    Utils.showLoadingDialog(context);
    try {
      // add auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailText.text,
        password: passwordText.text,
      );

      //get cut user
      MyUser user = getCurUser(credential.user!.uid);

      if (credential.user!.emailVerified == false) {
        //send email
        var user2 = FirebaseAuth.instance.currentUser;
        await user2!.sendEmailVerification();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifiedScreen(
                  credential, user, emailText.text, passwordText.text)),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'email-already-in-use') {
        Utils.showAlertDialog(context, () {
          Navigator.pop(context);
        }, "User already exist");
      }
    } catch (e) {
      return;
    }
  }

  getCurUser(String myId) {
    return MyUser(id: myId, name: fullNameText.text, email: emailText.text);
  }

  gotToLogin() {
    Fluttertoast.showToast(msg: "Sign up successfully");
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LogInScreen.routeName);
    });
  }
}
