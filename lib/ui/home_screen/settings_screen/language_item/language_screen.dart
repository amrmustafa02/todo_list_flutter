import 'package:flutter/material.dart';
import 'package:to_do/ui/home_screen/settings_screen/language_item/lan_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget{
  const LanguageScreen({super.key});

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
          LanguageItem(text: "English", lang:"en"),
          LanguageItem(text: "العربية", lang:"ar"),

        ],
      ),
    );
  }

}