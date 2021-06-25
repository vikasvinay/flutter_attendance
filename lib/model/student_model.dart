import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? name;
  String? uid;
  String? email;
  String? type;
  int? totalPresent;
  int? totalAbsent;
  List? enrolledSubjects;
  String? photoUrl;
  String? studentYear;
  String? branch;

  StudentModel(
      {this.email,
      this.studentYear,
      this.totalAbsent,
      this.totalPresent,
      this.name,
      this.enrolledSubjects,
      this.type,
      this.photoUrl,
      this.branch,
      this.uid});

  Map<String, dynamic> toFireStore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    map['student_year'] = this.studentYear;
    map['name'] = this.name;
    map['total_present'] = this.totalPresent;
    map['total_absent'] = this.totalAbsent;
    map['type'] = this.type;
    map['enrolled_subjects'] = this.enrolledSubjects;
    map['branch'] = this.branch;
    map['uid'] = this.uid;
    return map;
  }

  factory StudentModel.fromFireStore(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    var data = (doc.data() as dynamic);
    return StudentModel(
        studentYear: data['student_year'] ?? 'I',
        email: data['email'],
        totalAbsent: data['total_absent'] ?? 0,
        totalPresent: data['total_present'] ?? 0,
        enrolledSubjects: data['enrolled_subjects'] ?? [''],
        name: data['name'],
        type: data['type'],
        photoUrl: data['photo_url'],
        branch: data['branch'] ?? 'CSE',
        uid: data['uid']);
  }
}
