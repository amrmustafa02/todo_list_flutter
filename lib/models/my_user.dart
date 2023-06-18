import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String? id;
  String? name;
  String? email;

  MyUser({this.id, required this.name, required this.email});

  Map<String, dynamic> toFireStore() {
    return {"id": id, "name": name, "email": email};
  }

  static MyUser fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data();
    return MyUser(
      id: data?["id"],
      name: data?["name"],
      email: data?["email"],
    );
  }
}
