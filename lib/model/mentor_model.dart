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
    var data = (doc.data() as dynamic);
    return MentorModel(
        email: data['email'],
        name: data['name'],
        type: data['type'],
        subjectName: data['enrolled_subjects'].runtimeType == String
            ? [data['enrolled_subjects']]
            : data['enrolled_subjects'],
        photoUrl: data['photo_url'],
        uid: data['uid']);
  }
}
