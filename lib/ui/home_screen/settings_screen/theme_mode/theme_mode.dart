import 'package:flutter/material.dart';
import 'package:to_do/ui/home_screen/settings_screen/theme_mode/mode_item.dart';
import 'package:to_do/ui/theming/m_them.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeModeScreen extends StatelessWidget {
  static String routeName = "dark-mode";

  const ChangeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ModeItem(text:AppLocalizations.of(context)!.light, mode: 1),
          ModeItem(text: AppLocalizations.of(context)!.dark, mode: 2),
          ModeItem(text: AppLocalizations.of(context)!.system, mode: 3),
        ],
      ),
    );
  }
}
