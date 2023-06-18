import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? title;
  String? desc;
  DateTime? date;
  bool? check;

  TaskModel({this.id, this.title, this.desc, this.date,this.check});

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "date": date?.microsecondsSinceEpoch,
      "check":check
    };
  }

  static TaskModel fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data();
    return TaskModel(
        id: data?["id"],
        title: data?["title"],
        desc: data?["desc"],
        check: data?["check"],
        date: DateTime.fromMicrosecondsSinceEpoch(data?["date"]));
  }
}
