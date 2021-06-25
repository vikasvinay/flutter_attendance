import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String? subjectName;
  Timestamp? timestamp;
  String? subjectId;
  int? absent;
  int? present;

  SubjectModel(
      {this.absent,
      this.present,
      this.subjectName,
      this.timestamp,
      this.subjectId});

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
    var data = (doc.data() as dynamic);

    return SubjectModel(
        absent: data['absent'],
        present: data['present'],
        subjectName: data['subject_name'],
        subjectId: data['subject_id'],
        timestamp: data['timestamp'] as Timestamp);
  }
}
