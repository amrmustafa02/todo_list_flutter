import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/ui/home_screen/tasks_screen/DateTimeLine/date_timeline_picker.dart';
import 'package:to_do/ui/home_screen/tasks_screen/task_item/task_item.dart';

// ignore: must_be_immutable
class TasksScreen extends StatefulWidget {
  static bool load = false;

  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(
      const Duration(seconds: 2),
          () async {
            if (TasksScreen.load == false) {
             await getTask();
            }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              width: 10,
            ),
            Text(
              "Todo",
              style: TextStyle(color: Colors.white, fontSize: 28),
            )
          ],
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          DateTimeLineScreen(),
          getMainWidget(),
        ],
      ),
    );
  }

  Future<void> getTask() async {
    var provider = Provider.of<TasksProvider>(context, listen: false);
    var d = Utils.dateIgnoreMilliseconds(DateTime.now());
    await provider.getTasks(d);
    await UserDataUtils.setLoadState(true);

    setState(() {

    });
  }

  Widget getMainWidget() {
    var provider = Provider.of<TasksProvider>(context);

    if (TasksScreen.load == false) {
      return getLoadWidget();
    }

    if (provider.tasks.isEmpty) {
      return getNoTasksWidget();
    } else {
      return getTasksWidget();
    }
  }

  Widget getNoTasksWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/list_icon.png",
              width: 70,
              height: 70,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "No Tasks Found",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTasksWidget() {
    var provider = Provider.of<TasksProvider>(context);
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => TaskItem(task: provider.tasks[index]),
        itemCount: provider.tasks.length,
      ),
    );
  }

  Widget getLoadWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
