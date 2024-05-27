import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../../../data/constans/color.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final pageC = Get.find<PageIndexController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warna3,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          Map<String, dynamic>? dataUser = snapshot.data?.data();
          String defaultProfile =
              'https://ui-avatars.com/api/?name=${dataUser?['name']}';
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('data tidak ditemukan'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        dataUser!['profile'] != null
                            ? dataUser['profile'] != ""
                                ? dataUser['profile']
                                : defaultProfile
                            : defaultProfile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                dataUser['name'].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                '${dataUser['email']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () =>
                    Get.toNamed(Routes.UPDATE_PROFILE, arguments: dataUser),
                leading: const Icon(Icons.person),
                title: const Text('Edit Profile'),
              ),
              ListTile(
                onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                leading: const Icon(Icons.vpn_key),
                title: const Text('Ubah Password'),
              ),
              if (dataUser['role'] == 'admin')
                ListTile(
                  onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  leading: const Icon(Icons.person_add),
                  title: const Text('Tambahkan Pegawai'),
                ),
              ListTile(
                onTap: () {
                  controller.logout();
                },
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        color: warna2,
        backgroundColor: warna4,
        activeColor: warna3,
        height: 60,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Finger Print'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
