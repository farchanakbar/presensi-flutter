import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final pageC = Get.find<PageIndexController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamRole(),
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
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${dataUser['name']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            dataUser['address'] != null
                                ? '${dataUser['address']['jalan'] != 'Jalan Tanpa Nama' ? '${dataUser['address']['jalan']}, ' : ''}${dataUser['address']['desa']}, ${dataUser['address']['kecamatan']}, ${dataUser['address']['kabupaten']}, ${dataUser['address']['provinsi']}'
                                : 'tidak ada lokasi',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dataUser['job']}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'NIP ${dataUser['nip']}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${dataUser['name']}'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: Colors.grey[200],
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastAbsen(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Column(
                                children: [
                                  Text('Masuk'),
                                  Text('belum absen'),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey,
                              ),
                              const Column(
                                children: [
                                  Text('Keluar'),
                                  Text('belum absen'),
                                ],
                              )
                            ],
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Column(
                                children: [
                                  Text('Masuk'),
                                  Text('belum absen'),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey,
                              ),
                              const Column(
                                children: [
                                  Text('Keluar'),
                                  Text('belum absen'),
                                ],
                              )
                            ],
                          );
                        }

                        Map<String, dynamic> data =
                            snapshot.data!.docs.last.data();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Masuk'),
                                Text(data['masuk'] != null
                                    ? '${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}'
                                    : 'belum absen'),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                const Text('Keluar'),
                                Text(data['keluar'] != null
                                    ? '${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}'
                                    : 'belum absen'),
                              ],
                            )
                          ],
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Last 5 days',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                      child: const Text('See more'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamLastAbsen(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text('belum ada absen'),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot
                              .data!.docs.reversed
                              .toList()[index]
                              .data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Material(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              child: InkWell(
                                onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI,
                                    arguments: data),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Masuk',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMMMEd().format(
                                                DateTime.parse(data['date'])),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(DateFormat.jms().format(
                                          DateTime.parse(
                                              data['masuk']['date']))),
                                      data['masuk']['status'] != 'Di Dalam Area'
                                          ? Text(
                                              'Absen ${data['masuk']['status']}',
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            )
                                          : Text(
                                              'Absen ${data['masuk']['status']}',
                                              style: const TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Keluar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['keluar'] != null
                                            ? DateFormat.jms().format(
                                                DateTime.parse(
                                                    data['keluar']['date']))
                                            : 'belum absen keluar',
                                      ),
                                      data['keluar'] != null
                                          ? data['masuk']['status'] !=
                                                  'Di Dalam Area'
                                              ? Text(
                                                  'Absen ${data['masuk']['status']}',
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Text(
                                                  'Absen ${data['masuk']['status']}',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ],
            );
          }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
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
