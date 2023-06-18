import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/database/MyDataBase.dart';

import '../database/user_utils.dart';
import '../models/task_model.dart';
import '../ui/home_screen/tasks_screen/tasks_screen.dart';

class TasksProvider extends ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var themeMode;
  var local;

  TasksProvider() {
    setMode();
    setLocal();
  }

  setMode() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? mode = _prefs.getInt("mode");
    if (mode == 1) {
      themeMode = ThemeMode.light;
    } else if (mode == 2) {
      themeMode = ThemeMode.dark;
    } else if (mode == 3) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.system;
    }
  }

  final MyDataBase _db = MyDataBase.getInstance();
  List<TaskModel> tasks = [];

  Future<void> addTask(TaskModel task) async {
    String? id = await UserDataUtils().getIdForCurUser();
    await _db.addTaskToCurrentUser(task, id!);
    await getTasks(Utils.dateIgnoreMilliseconds(Utils.selectedDate));
    TasksScreen.load = true;
    notifyListeners();
  }

  Future<void> getTasks(DateTime dateTime) async {
    String? id = await UserDataUtils().getIdForCurUser();
    var tasks1 = await _db.getTasksForUser(id!, dateTime);
    tasks = tasks1.docs.map((snap) => snap.data()).toList();
    TasksScreen.load = true;
    // notifyListeners();
  }

  Future<void> getTasksTime(DateTime dateTime)async{
    String? id = await UserDataUtils().getIdForCurUser();
    var tasks1 = await _db.getTasksForUser(id!, dateTime);
    tasks = tasks1.docs.map((snap) => snap.data()).toList();
    TasksScreen.load = true;

    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    String? id = await UserDataUtils().getIdForCurUser();
    var tasks1 = MyDataBase.getTasksCollectionToUser(id!);
    await tasks1.doc(taskId).delete();
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].id == taskId) {
        tasks.removeAt(i);
        break;
      }
    }
    TasksScreen.load = true;

    notifyListeners();
  }

  Future<void> updateTask(TaskModel taskModel, DateTime dateTime) async {
    String? id = await UserDataUtils().getIdForCurUser();
    MyDataBase db = MyDataBase.getInstance();
    await db.updateTask(taskModel, id!);
    await getTasks(Utils.dateIgnoreMilliseconds(dateTime));
    TasksScreen.load = true;
    notifyListeners();
  }

  Future<void> changeMode(int mode) async {
    await UserDataUtils.saveThemeMode(mode);
    if (mode == 1) {
      themeMode = ThemeMode.light;
    } else if (mode == 2) {
      themeMode = ThemeMode.dark;
    } else if (mode == 3) {
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
  updateLocal(String loc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("local", loc);
    local = Locale(loc);
    notifyListeners();
  }
  Future<void> setLocal() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
   String? loc = _prefs.getString("local");
    if(loc!=null){
      local = Locale(loc);
    }else{
      local = const Locale("en");
    }
    notifyListeners();
  }
}
