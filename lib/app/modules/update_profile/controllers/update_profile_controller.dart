import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.name);
      print(image!.path);
    } else {
      print(image);
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          'name': nameC.text,
        };

        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          await firebaseStorage.ref().child("$uid/profile.$ext").putFile(file);
          String urlProfile = await firebaseStorage
              .ref()
              .child("$uid/profile.$ext")
              .getDownloadURL();

          data.addAll({'profile': urlProfile});
        }
        await firestore.collection('pegawai').doc(uid).update(data);
        image = null;

        Get.back();
        Get.snackbar('Berhasil', 'Berhasil update profile');
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Gagal update profile');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Data tidak boleh kosong');
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection('pegawai').doc(uid).update(
        {
          'profile': FieldValue.delete(),
        },
      );
      Get.back();
      Get.snackbar('Behasil', 'berhasil menghapus profile');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'gagal menghapus profile');
    }
  }
}
