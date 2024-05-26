import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamRole() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection('pegawai').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastAbsen() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection('pegawai')
        .doc(uid)
        .collection('absen')
        .orderBy('date', descending: true)
        .limit(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayAbsen() async* {
    String uid = auth.currentUser!.uid;

    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');

    yield* firestore
        .collection('pegawai')
        .doc(uid)
        .collection('absen')
        .doc(todayID)
        .snapshots();
  }
}
