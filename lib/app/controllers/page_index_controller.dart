import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['posisi'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          String address =
              '${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea},';
          await updatePosition(position, placemarks);

          // cek distance absen
          double distance = Geolocator.distanceBetween(
            -1.16228,
            102.1535356,
            position.latitude,
            position.longitude,
          );

          // presensi
          await presensi(position, address, distance);

          Get.snackbar(
            'Berhasil',
            'Telah berhasil absen hari ini',
          );
        } else {
          Get.snackbar('Terjadi Kesalahan', '${dataResponse['message']}');
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colAbsen =
        firestore.collection('pegawai').doc(uid).collection('absen');
    QuerySnapshot<Map<String, dynamic>> snapAbsen = await colAbsen.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll('/', '-');

    String status = 'Di Luar Area';

    if (distance <= 50) {
      status = 'Di Dalam Area';
    }

    if (snapAbsen.docs.isEmpty) {
      await colAbsen.doc(todayDocId).set({
        'date': now.toIso8601String(),
        'masuk': {
          'date': now.toIso8601String(),
          'lat': position.latitude,
          'long': position.longitude,
          'address': address,
          'status': status,
          'distance': distance,
        }
      });
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colAbsen.doc(todayDocId).get();

      Map<String, dynamic>? todayData = todayDoc.data();

      if (todayDoc.exists == true) {
        if (todayData!['keluar'] != null) {
          Get.snackbar('Sukses', 'kamu telah selesai absen hari ini');
        } else {
          await colAbsen.doc(todayDocId).update(
            {
              'keluar': {
                'date': now.toIso8601String(),
                'lat': position.latitude,
                'long': position.longitude,
                'address': address,
                'status': status,
                'distance': distance,
              }
            },
          );
        }
      } else {
        // absen masuk
        await colAbsen.doc(todayDocId).set(
          {
            'date': now.toIso8601String(),
            'masuk': {
              'date': now.toIso8601String(),
              'lat': position.latitude,
              'long': position.longitude,
              'address': address,
              'status': status,
              'distance': distance,
            }
          },
        );
      }
    }
  }

  Future<void> updatePosition(
      Position position, List<Placemark> placemark) async {
    String uid = auth.currentUser!.uid;
    await firestore.collection('pegawai').doc(uid).update(
      {
        'position': {
          'lat': position.latitude,
          'long': position.longitude,
        },
        'address': {
          'jalan': placemark[0].street,
          'desa': placemark[0].subLocality,
          'kecamatan': placemark[0].locality,
          'kabupaten': placemark[0].subAdministrativeArea,
          'provinsi': placemark[0].administrativeArea,
          'negara': placemark[0].country,
        }
      },
    );
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        'message': 'Aktifkan lokasi anda',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          'message': 'Izin akses lokasi ditolak',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message': 'Settingan menolak untuk akses lokasi, aktifkan kembali',
        'error': true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'posisi': position,
      'message': 'Berhasil mendapatkan posisi device',
      'error': false
    };
  }
}
