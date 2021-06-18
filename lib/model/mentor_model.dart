import 'package:cloud_firestore/cloud_firestore.dart';

class MentorModel {
  String? name;
  String? uid;
  String? email;
  String? type;
  List? subjectName;
  String? photoUrl;

  MentorModel({this.email, this.name, this.type, this.subjectName, this.uid, this.photoUrl});

  Map<String, dynamic> toFireStore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    map['name'] = this.name;
    map['type'] = this.type;
    map['enrolled_subjects'] = this.subjectName;
    map['uid'] = this.uid;
    return map;
  }

  factory MentorModel.fromFireStore({required DocumentSnapshot doc}) {
    return MentorModel(
        email: doc['email'],
        name: doc['name'],
        type: doc['type'],
        subjectName: doc['enrolled_subjects'].runtimeType == String
            ? [doc['enrolled_subjects']]
            : doc['enrolled_subjects'],
        photoUrl: doc['photo_url'],
        uid: doc['uid']);
  }
}
