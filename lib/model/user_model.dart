import 'package:flutter/material.dart';

class UsersModel {
  String name;
  String uid;
  String email;
  String type;

  UsersModel(
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

  factory UsersModel.fromFireStore({required AsyncSnapshot doc}) {
    return UsersModel(
        email: doc.requireData['email'],
        name: doc.requireData['name'],
        type: doc.requireData['type'],
        uid: doc.requireData['uid']);
  }
}
