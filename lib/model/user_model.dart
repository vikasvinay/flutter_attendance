import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String uid;
  String email;
  String type;


  UserModel(
      {required this.email,
      required this.name,
      required this.type,
      required this.uid});

  Map<String, dynamic> toFireStore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    map['name'] = this.name;
    map['type'] = this.type;
    map['uid'] = this.uid;
    return map;
  }

  factory UserModel.fromFireStore({required DocumentSnapshot doc}) {
        var data = (doc.data() as dynamic);

    return UserModel(
        email: data['email'],
        name: data['name'],
        type: data['type'],
        uid: data['uid']);
  }
}
