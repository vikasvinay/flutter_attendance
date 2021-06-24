import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String name;
  String uid;
  String email;
  String type;
  int totalPresent;
  int totalAbsent;
  List enrolledSubjects;
  String? photoUrl;
  String studentYear;

  StudentModel(
      {required this.email,
      required this.studentYear,
      required this.totalAbsent,
      required this.totalPresent,
      required this.name,
      required this.enrolledSubjects,
      required this.type,
      this.photoUrl,
      required this.uid});

  Map<String, dynamic> toFireStore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    map['student_year'] = this.studentYear;
    map['name'] = this.name;
    map['total_present'] = this.totalPresent;
    map['total_absent'] = this.totalAbsent;
    map['type'] = this.type;
    map['enrolled_subjects'] = this.enrolledSubjects;
    map['uid'] = this.uid;
    return map;
  }

  factory StudentModel.fromFireStore({required DocumentSnapshot doc}) {
    return StudentModel(
        studentYear: doc.get('student_year') ?? 'I',
        email: doc.get('email'),
        totalAbsent: doc.get('total_absent') ?? 0,
        totalPresent: doc.get('total_present') ?? 0,
        enrolledSubjects: doc.get('enrolled_subjects') ?? [''],
        name: doc.get('name'),
        type: doc.get('type'),
        photoUrl: doc.get('photo_url'),
        uid: doc.get('uid'));
  }
}
