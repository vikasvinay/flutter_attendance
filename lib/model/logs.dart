import 'package:cloud_firestore/cloud_firestore.dart';

class Logs {
  int? timestamp;
  String? subjectName;
  String? attendance;
  String? logId;

  Logs({this.attendance, this.logId, this.subjectName, this.timestamp});

  Map<String, dynamic> toFireStore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['attendance'] = this.attendance;
    map['timestamp'] = this.timestamp;
    map['log_id'] = this.logId;
    map['subject_name'] = this.subjectName;
    return map;
  }

  factory Logs.fromFirestore({required DocumentSnapshot doc}) {
    return Logs(
        attendance: doc['attendance'],
        subjectName: doc['subject_name'],
        timestamp: doc['timestamp']);
  }
}
