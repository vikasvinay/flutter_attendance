import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String? subjectName;
  Timestamp? timestamp;
  String? subjectId;
  int? absent;
  int? present;

  SubjectModel({this.absent, this.present, this.subjectName, this.timestamp, this.subjectId});

  Map<String, dynamic> toFirestore({Map<String, dynamic>? map}) {
    Map<String, dynamic> map = {};
    map['subject_name'] = this.subjectName;
    map['timestamp'] = this.timestamp;
    map['absent'] = this.absent;
    map['present'] = this.present;
    map['subject_id'] = this.subjectId;
    return map;
  }

  factory SubjectModel.fromFirestore({required DocumentSnapshot doc}) {
    return SubjectModel(
        absent: doc['absent'],
        present: doc['present'],
        subjectName: doc['subject_name'],
        subjectId: doc['subject_id'],
        timestamp: doc['timestamp'] as Timestamp);
  }
}
