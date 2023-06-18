import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Utils {
  static DateTime selectedDate = DateTime.now();

  static String? checkEmail(String text) {
    if (text.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text)) {
      return "please enter valid email";
    }
    return null;
  }

  static String? checkPassword(String text) {
    if (text.isEmpty) {
      return "Please enter your password";
    }
    if (text.length < 6) {
      return "please enter at least 6 character";
    }
    return null;
  }

  static String getDateFormat(DateTime dateTime, String local) {
    var formatter = DateFormat.yMMMd(local);
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static void showBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(

        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(AppLocalizations.of(context)!.load)
                ],
              ),
            ),
          );
        });
  }

  static Widget getAlert(String text, Function fun) {
    return AlertDialog(
      title: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            fun();
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }

  static Widget getShowMessage(String text, BuildContext context,
      Function okFunction, Function cancelFunction) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(text),
      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      actions: [
        TextButton(
          onPressed: () {
            okFunction();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
        TextButton(
          onPressed: () {
            cancelFunction();
          },
          child: Text(AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  static void showAlertDialog(BuildContext context, Function fun, String text) {
    showDialog(context: context, builder: (context) => getAlert(text, fun));
  }

  static DateTime dateIgnoreMilliseconds(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static void getMessage(
      BuildContext context, String text, Function ok, Function cancel) {
    showDialog(
        context: context,
        builder: (context) => getShowMessage(text, context, ok, cancel));
  }
}
