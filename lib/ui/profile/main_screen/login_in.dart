import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do/database/MyDataBase.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/models/my_user.dart';
import 'package:to_do/ui/home_screen/home_screen.dart';
import 'package:to_do/ui/home_screen/settings_screen/password/change_password_screen.dart';
import 'package:to_do/ui/profile/main_screen/register_screen.dart';
import 'package:to_do/ui/profile/sub_widgets/MyTextField.dart';

import '../../../controllers/Utils.dart';
import '../sub_widgets/MyPasswordFIeld.dart';
import '../sub_widgets/profile_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class LogInScreen extends StatefulWidget {
  static String routeName = "login_screen";

  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  MyDataBase base = MyDataBase.getInstance();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  Utils ctrl = Utils();
  var formKey = GlobalKey<FormState>();
  bool autoSave = false;
  Color checkBoxColor = Colors.blue;

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
            "Login",
            style: TextStyle(fontSize: 24),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    MyTextField("Email", emailText, const Icon(Icons.email),
                        (text) {
                      return Utils.checkEmail(text!);
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    MyPasswordField(passwordText, (text) {
                      if (text!.isEmpty) {
                        return "please enter password";
                      }
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Remember me",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        getCheckBox()
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 55,
                      child: ProfileButton("Login", login),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, SignUpScreen.routeName);
                            },
                            child: const Text("Sign up"))
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Utils.showBottomSheet(
                              context, ChangePasswordScreen());
                        },
                        child: const Text("Forget password?"))
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    // check validation
    if (formKey.currentState?.validate() == false) {
      return;
    }

    // show dialog
    Utils.showLoadingDialog(context);

    // save auto login choice
    await saveRememberMe();

    // check database
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailText.text, password: passwordText.text);

      // reload cur user
      await FirebaseAuth.instance.currentUser!.reload();

      // check if email verified
      if (checkEmailVerified() == false) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        // ignore: use_build_context_synchronously
        Utils.showAlertDialog(context, () {
          Navigator.pop(context);
        }, "Please verified your email first,we send email again");
        return;
      }

      // get user from fire store
      MyUser? user = await base.getUser(credential.user!.uid);

      goToHomeScreen(user);
      // check on user if exist or not
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        Utils.showAlertDialog(context, () {
          Navigator.pop(context);
        }, "User not exist");
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        Utils.showAlertDialog(context, () {
          Navigator.pop(context);
        }, "Wrong password");
      }
    }
  }

  Widget getCheckBox() {
    return Checkbox(
      value: autoSave,
      checkColor: Colors.white,
      hoverColor: Colors.blue,
      focusColor: Colors.blue,
      fillColor: MaterialStateProperty.resolveWith((states) {
        return checkBoxColor;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onChanged: (value) {
        autoSave = value!;
        setState(() {});
      },
    );
  }

  Future<void> saveRememberMe() async {
    UserDataUtils.saveAutoLogin(autoSave);
  }

  bool checkEmailVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    // check if email verified
    if (user!.emailVerified == false) {
      user.sendEmailVerification();
      return false;
    }
    return true;
  }

  goToHomeScreen(MyUser? user) {
    if (user != null) {
      // got to home screen
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          UserDataUtils.saveUserName(user.name!);
          Navigator.of(context).pop();
          return Navigator.pushReplacementNamed(context, HomeScreen.routeName,
              arguments: user);
        },
      );
    } else {
      Fluttertoast.showToast(msg: "some error is found, please try again");
    }
  }
}
