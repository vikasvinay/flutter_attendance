import 'package:attendance_app/model/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  LogRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = FirebaseFirestore.instance;

  Logs _logs = Logs();

  Stream<List<Logs>> getAllLogs({required String useruid}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = firebaseFirestore
        .collection('users')
        .doc(useruid)
        .collection('logs')
        .snapshots();

    return data.asyncMap((loggs) =>
        loggs.docs.map((log) => Logs.fromFirestore(doc: log)).toList());
  }

  Future<void> createLog(
      {required String subjectName, required bool isPresent}) async {
    DocumentReference<Map<String, dynamic>> docId = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('logs')
        .doc();

    _logs.attendance = isPresent ? 'Present' : 'Absent';
    _logs.logId = docId.id;
    _logs.subjectName = subjectName;
    _logs.timestamp = DateTime.now().millisecondsSinceEpoch;
    await docId.set(_logs.toFireStore(), SetOptions(merge: true));
  }

  Future<void> logSubjectAdd(
      {required String subjectName}) async {
    DocumentReference<Map<String, dynamic>> docId = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('logs')
        .doc();

    _logs.attendance = subjectName;
    _logs.logId = docId.id;
    _logs.subjectName = subjectName;
    _logs.timestamp = DateTime.now().millisecondsSinceEpoch;
    await docId.set(_logs.toFireStore(), SetOptions(merge: true));
  }

}
