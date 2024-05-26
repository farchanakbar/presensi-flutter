import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllAbsen() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection('pegawai')
        .doc(uid)
        .collection('absen')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
