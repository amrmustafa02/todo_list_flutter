import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/ui/home_screen/home_screen.dart';
import 'package:to_do/ui/home_screen/settings_screen/theme_mode/theme_mode.dart';
import 'package:to_do/ui/profile/main_screen/login_in.dart';
import 'package:to_do/ui/profile/main_screen/register_screen.dart';
import 'package:to_do/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do/ui/theming/m_them.dart';
import 'database/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => TasksProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);

    return MaterialApp(
      supportedLocales:AppLocalizations.supportedLocales,
      localizationsDelegates:AppLocalizations.localizationsDelegates,
      locale: provider.local,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: provider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        HomeScreen.routeName: (_) =>  HomeScreen(),
        LogInScreen.routeName: (_) => LogInScreen(),
        SignUpScreen.routeName: (_) => SignUpScreen(),
        ChangeModeScreen.routeName: (_) => const ChangeModeScreen(),
      },
    );
  }
}
