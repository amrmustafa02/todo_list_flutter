import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/database/MyDataBase.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/ui/edit_screen/TaskFormField.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theming/m_them.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  EditScreen({super.key, required this.taskModel});

  TaskModel taskModel;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool checkEdit = false;
  Color color = Colors.black;
  Color checkBoxColor = Colors.blue;
  bool enable = false;
  TextEditingController titleText = TextEditingController();
  TextEditingController descText = TextEditingController();
  late DateTime selectedDate;
  late DateTime oldDate;
  late String dateText;
  var formKey = GlobalKey<FormState>();
  late String title;
  late String desc;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.taskModel.date!;
    oldDate = selectedDate;
    formatData(selectedDate);
    title = widget.taskModel.title!;
    desc = widget.taskModel.desc!;

  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    return Container(
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
                      TaskTextField(
                          AppLocalizations.of(context)!.title,
                          titleText,
                          1,
                          title,
                          enable,
                              (text) =>
                          text!.isEmpty ? "Please enter title" : null),
                      TaskTextField(
                          AppLocalizations.of(context)!.desc,
                          descText,
                          4,
                         desc,
                          enable,
                              (p0) => null),
                      Row(
                        children: [
                          getEditDate(),
                          const Spacer(),
                          getCheckBox(),
                        ],
                      ),
                      !checkEdit
                          ? getOkWidget()
                          : Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            getButton(
                                Colors.red,
                                AppLocalizations.of(context)!.cancel,
                                clickOnCancelButton),
                            getButton(Colors.blue,
                                AppLocalizations.of(context)!.save,
                                    () async {
                                  if (formKey.currentState!.validate() ==
                                      false) {
                                    return;
                                  }
                                  await clickOnSaveButton();
                                  // ignore: use_build_context_synchronously
                                  await provider.updateTask(
                                      widget.taskModel, oldDate);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }),
                          ],
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
    );
  }

  Widget getButton(Color color, String text, Function fun) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: color),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                elevation: 0,
                backgroundColor: color),
            onPressed: () {
              fun();
            },
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            )),
      ),
    );
  }

  Widget getOkWidget() {
    return Row(
      children: [
        getButton(Colors.blue, AppLocalizations.of(context)!.ok, () {
          Navigator.pop(context);
        }),
      ],
    );
  }

  void clickOnCancelButton() {
    // return check box to false
    checkEdit = false;
    enable = false;
    selectedDate = widget.taskModel.date!;
    formatData(selectedDate);
    checkBoxColor = (checkEdit ? Colors.green : Colors.blue);
    enable = false;
    // rebuild
    setState(() {});
  }

  Future<void> clickOnSaveButton() async {
    Utils.showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1));
    // update data in model
    widget.taskModel.title = titleText.text;
    widget.taskModel.desc = descText.text;
    widget.taskModel.date = selectedDate;
  }

  Widget getCheckBox() {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.edit,
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
        ),
        Checkbox(
          value: checkEdit,
          checkColor: Colors.white,
          activeColor: Colors.green,
          hoverColor: Colors.blue,
          focusColor: Colors.blue,
          fillColor: MaterialStateProperty.resolveWith((states) {
            return checkBoxColor;
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (value) {
            changeCheckBox();
            setState(() {});
          },
        ),
      ],
    );
  }

  void changeCheckBox() {
    checkEdit = !checkEdit;
    checkBoxColor = (checkEdit ? Colors.green : Colors.blue);
    enable = !enable;
  }

  getEditDate() {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Row(
        children: [
          IconButton(
            onPressed: enable
                ? () {
              _showDataPicker();
            }
                : null,
            icon: const Icon(
              Icons.date_range_rounded,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Text(
            dateText,
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
          ),
        ],
      ),
    );
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
              dialogBackgroundColor: Theme
                  .of(context)
                  .primaryColor),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime
          .now()
          .year - 0, DateTime
          .now()
          .month - 0,
          DateTime
              .now()
              .day - 0),
      lastDate: DateTime(DateTime
          .now()
          .year + 5),
    ).then((value) {
      formatData(value!);
      selectedDate = value;
    });
  }

  void formatData(DateTime dateTime) {
    setState(() {
      var provider = Provider.of<TasksProvider>(context, listen: false);
      String local = provider.local == const Locale("en") ? 'en' : 'ar';
      dateText = Utils.getDateFormat(dateTime, local);
    });
  }
}
