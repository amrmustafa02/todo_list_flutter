import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/ui/edit_screen/edit_screen.dart';
import 'package:to_do/ui/home_screen/tasks_screen/task_item/task_desc_screen.dart';
import 'package:to_do/ui/theming/m_them.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  TaskModel task;

  TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool checkDone;
  Color mainColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    checkDone = widget.task.check!;
    changeColor();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    checkDone = widget.task.check!;
    changeColor();
    return Container(
      margin: const EdgeInsets.all(3),
      height: 100,
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(3),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Checkbox(
                value: checkDone,
                checkColor: Colors.white,
                activeColor: Colors.green,
                hoverColor: Colors.blue,
                focusColor: Colors.blue,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return mainColor;
                }),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onChanged: (value) async {
                  checkDone = !checkDone;
                  updateTaskCheck();
                  changeColor();
                  setState(() {});
                },
              ),

              Expanded(
                child: InkWell(
                  onTap: (){
                    Utils.showBottomSheet(context, TaskDesc(text: widget.task.desc!,));
                  },
                  child: Text(
                    widget.task.title ?? "",
                    style: getTextStyle(),
                    overflow: TextOverflow.ellipsis, // new
                  ),
                ),
              ),

              IconButton(
                  onPressed: () {
                    Utils.showBottomSheet(
                        context,
                        EditScreen(
                          taskModel: widget.task,
                        ));
                  },
                  icon:  Icon(
                    Icons.edit,
                    color: MyTheme.lightPrimaryColor,
                  )),
              IconButton(
                  onPressed: () {
                    Utils.getMessage(context,AppLocalizations.of(context)!.deleteMessage, (){
                      provider.deleteTask(widget.task.id!);
                      Navigator.pop(context);
                    }, (){
                      Navigator.pop(context);
                    });
                    setState(() {
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  TextStyle getTextStyle() {
    return TextStyle(
        decoration: checkDone ? TextDecoration.lineThrough : null,
        color: mainColor,
        fontSize: 22,
        fontWeight: FontWeight.w500);
  }

  TextStyle getTextStyle2() {
    return TextStyle(
        decoration: checkDone ? TextDecoration.lineThrough : null,
        color: mainColor,
        fontSize: 18,
        fontWeight: FontWeight.w500);
  }

  updateTaskCheck() async {
    widget.task.check = checkDone;
    var provider = Provider.of<TasksProvider>(context, listen: false);
    await provider.updateTask(widget.task,widget.task.date!);
  }

  changeColor() {
    if (checkDone) {
      mainColor = Colors.green;
    } else {
      mainColor = Colors.blue;
    }
  }
}
