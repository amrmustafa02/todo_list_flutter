import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/database/MyDataBase.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/ui/add_task/TaskFormField.dart';
import 'package:to_do/ui/theming/m_them.dart';

import '../../database/user_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class BottomSheetScreen extends StatefulWidget {
  String dateText = "";
  String selectedDate = "";
  BottomSheetScreen({required this.dateText, super.key});

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  TextEditingController titleText = TextEditingController();
  TextEditingController descText = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
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
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        // const Icon(Icons.menu_rounded,color: Colors.blue,),
                        TaskTextField(AppLocalizations.of(context)!.title, 1,
                            true, titleText, (p0) {
                          if (p0!.isEmpty) {
                            return AppLocalizations.of(context)!.handleTitle;
                          }
                        }, Icons.title_sharp),

                        TaskTextField(
                          AppLocalizations.of(context)!.desc,
                          4,
                          true,
                          descText,
                          (p0) {
                            if (p0!.isEmpty) {
                              return AppLocalizations.of(context)!.handleDesc;
                            }
                            return null;
                          },
                          Icons.description,
                        ),

                        Container(
                          margin: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showDataPicker();
                                },
                                icon: const Icon(
                                  Icons.date_range_rounded,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              Text(
                                widget.dateText,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                elevation: 0,
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              clickOnAdd();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.add,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clickOnAdd() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    Utils.showLoadingDialog(context);

    await Future.delayed(const Duration(seconds: 1));

    // ignore: use_build_context_synchronously
    var provider = Provider.of<TasksProvider>(context, listen: false);

    // format date
    DateTime dateTime = Utils.dateIgnoreMilliseconds(selectedDate);
    print(dateTime.microsecondsSinceEpoch);
    await provider.addTask(TaskModel(
        title: titleText.text,
        desc: descText.text,
        date: dateTime,
        check: false));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _showDataPicker() {
    // int currentYear = int.parse(Format .format(DateTime.now()));
    var picker = showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
                primary: MyTheme.btrolColor, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.blue,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // button text color
                ),
              ),
              dialogBackgroundColor: Theme.of(context).primaryColor),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 0, DateTime.now().month - 0,
          DateTime.now().day - 0),
      lastDate: DateTime(DateTime.now().year + 5),
    ).then((value) {
      formatData(value!);
      selectedDate = value;
    });
  }

  void formatData(DateTime dateTime) {
    setState(() {
      var provider = Provider.of<TasksProvider>(context, listen: false);
      String local = provider.local == const Locale("en") ? 'en' : 'ar';
      widget.dateText = Utils.getDateFormat(dateTime,local);
    });
  }
}
