import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/database/user_utils.dart';
import 'package:to_do/models/my_user.dart';
import 'package:to_do/models/task_model.dart';

class MyDataBase {
  static MyDataBase? _instance;

  static final _db = FirebaseFirestore.instance;

  MyDataBase._();

  static MyDataBase getInstance() {
    _instance ??= MyDataBase._();
    return _instance!;
  }

  static CollectionReference<MyUser> _userCollection() {
    return _db.collection("users").withConverter<MyUser>(
          fromFirestore: MyUser.fromFireStore,
          toFirestore: (MyUser user, _) => user.toFireStore(),
        );
  }

  getTasksCollection() {
    return _db.collection("tasks").withConverter<TaskModel>(
          fromFirestore: TaskModel.fromFireStore,
          toFirestore: (TaskModel user, _) => user.toFireStore(),
        );
  }

  static CollectionReference<TaskModel> getTasksCollectionToUser(String id) {
    return _userCollection()
        .doc(id)
        .collection("tasks")
        .withConverter<TaskModel>(
            fromFirestore: TaskModel.fromFireStore,
            toFirestore: (TaskModel user, _) => user.toFireStore());
  }

  Future<void> addUser(MyUser user) async {
    var collection = _userCollection();
    await collection.doc(user.id).set(user);
  }


  Future<MyUser?> getUser(String id) async {
    final docRef = _userCollection().doc(id).withConverter(
          fromFirestore: MyUser.fromFireStore,
          toFirestore: (MyUser user, options) => user.toFireStore(),
        );
    var sh = await docRef.get();
    MyUser? user = sh.data();
    return user;
  }

  Future<void> addTaskToCurrentUser(TaskModel task, String id) async {
    CollectionReference collectionReference = getTasksCollectionToUser(id);
    var newTask = collectionReference.doc();
    task.id = newTask.id;
    newTask.set(task);
  }

  Future<void> updateTask(TaskModel task, String id) async {
    CollectionReference collectionReference = getTasksCollectionToUser(id);
    var newTask = collectionReference.doc(task.id);
    newTask.set(task);
  }

  Future<QuerySnapshot<TaskModel>> getTasksForUser(
      String id, DateTime dateTime) {
    print("---------${dateTime.microsecondsSinceEpoch}----");
    return getTasksCollectionToUser(id)
        .where('date', isEqualTo: dateTime.microsecondsSinceEpoch)
        .get();
  }
}
