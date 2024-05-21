import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordC.text == 'admin1234') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: 'Verifikasi Email',
              middleText: 'Email belum di verifikasi, silahkan cek email anda!',
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        'Berhasil',
                        'Berhasil kirim ulang verifikasi!',
                      );
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar(
                        'Gagal',
                        'Gagal mengirim ulang email verifikasi',
                      );
                    }
                  },
                  child: const Text('KIRIM ULANG'),
                )
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        print(e.code);
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Email tidak ditemukan');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah');
        }
        Get.snackbar('Terjadi Kesalahan', '$e');
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Terjadi Kesalahan', 'Login gagal');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email dan password wajib diisi');
    }
  }
}
