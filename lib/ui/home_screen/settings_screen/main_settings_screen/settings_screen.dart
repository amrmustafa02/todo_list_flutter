import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/ui/home_screen/settings_screen/language_item/language_screen.dart';
import 'package:to_do/ui/home_screen/settings_screen/main_settings_screen/setting_item.dart';
import 'package:to_do/ui/home_screen/settings_screen/theme_mode/theme_mode.dart';
import 'package:to_do/ui/home_screen/tasks_screen/tasks_screen.dart';
import 'package:to_do/ui/profile/main_screen/login_in.dart';

import '../../../../controllers/TasksProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    TasksScreen.load = false;
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    String text;
    if (FirebaseAuth.instance.currentUser == null) {
      text = "";
    } else {
      text = FirebaseAuth.instance.currentUser!.email!;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                "assets/images/user.png",
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                UserDataUtils.userName ?? "",
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
               text,
              ),
              const SizedBox(
                height: 50,
              ),
              SettingItem(
                  fun: () {
                    Utils.getMessage(context,
                        AppLocalizations.of(context)!.resetPasswordMessage, () {
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: FirebaseAuth.instance.currentUser!.email!);
                      Navigator.pop(context);
                    }, () {
                      Navigator.of(context).pop();
                    });
                  },
                  iconData: Icons.lock,
                  text: AppLocalizations.of(context)!.resetPassword),
              SettingItem(
                  fun: () {
                    Utils.showBottomSheet(context, const ChangeModeScreen());
                  },
                  iconData: Icons.dark_mode,
                  text: AppLocalizations.of(context)!.mode),
              SettingItem(
                  fun: () {
                    Utils.showBottomSheet(context, const LanguageScreen());
                  },
                  iconData: Icons.language,
                  text: AppLocalizations.of(context)!.lan),
              SettingItem(
                  fun: () {
                    Utils.getMessage(
                        context, AppLocalizations.of(context)!.logoutMessage,
                        // ok message
                        () async {
                      await UserDataUtils.saveAutoLogin(false);

                      FirebaseAuth.instance.signOut();

                      await provider.changeMode(1);
                      await provider.updateLocal('en');

                      TasksScreen.load = false;

                      provider.tasks = [];

                      // ignore: use_build_context_synchronously
                      Navigator.pushNamedAndRemoveUntil(
                          context, LogInScreen.routeName, (route) => false );
                    }, () {
                      Navigator.of(context).pop();
                    });
                  },
                  iconData: Icons.logout,
                  text: AppLocalizations.of(context)!.logOut),
            ],
          ),
        ),
      ),
    );
  }
}
