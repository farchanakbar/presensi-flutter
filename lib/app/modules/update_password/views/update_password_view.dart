import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/data/constans/color.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warna3,
        title: const Text('Ubah Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.currC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Password Sebelumnya'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.newC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Password Baru'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.conNewC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Konfirmasi Password Baru'),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.gantiPassword();
                }
              },
              child: Text(
                controller.isLoading.isFalse ? 'Ganti password' : 'Loading...',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
