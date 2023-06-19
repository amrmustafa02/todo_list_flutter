// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/ui/home_screen/home_screen.dart';
import 'package:to_do/ui/profile/main_screen/login_in.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "splash_screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (FirebaseAuth.instance.currentUser != null) {
          bool? check = await UserDataUtils.getAutoLoginValue();
          if (check != null && check != false) {
            await UserDataUtils.loadUserName();
            await provider.setLocal();
            await provider.setMode();

            Navigator.pushReplacementNamed(context, HomeScreen.routeName);

            return;
          }
        }

        await provider.updateLocal('en');
        await provider.changeMode(1);
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      },
    );

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                    child: Image.asset(
                  "assets/images/todo-list.png",
                  height: 100,
                  width: 100,
                )),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Todo",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 25,
                ),
                const CircularProgressIndicator(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("made by", style: TextStyle(color: Colors.blue)),
                    Text(" Amr mustafa",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
