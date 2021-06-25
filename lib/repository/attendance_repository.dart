import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  AttendanceRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> addAttendance(
      {required bool isPresent,
      required String subjectId,
      required String studentUid}) async {
    String type = isPresent ? 'present' : 'absent';
    String mainType = isPresent ? 'total_present' : 'total_absent';
    await firebaseFirestore
        .collection('users')
        .doc(studentUid)
        .collection('subjects')
        .doc(subjectId)
        .update({type: FieldValue.increment(1)});
    await firebaseFirestore.collection('users').doc(studentUid).update(
      {
        mainType: FieldValue.increment(1),
      },
    );
  }
}
