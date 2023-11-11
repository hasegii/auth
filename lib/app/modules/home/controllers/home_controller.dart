import 'package:auth/app/data/network_statuses/network_status.dart';
import 'package:auth/app/data/services/storage_service.dart';
import 'package:auth/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final nameController = TextEditingController();
  final passController = TextEditingController();

  final _status = NetworkStatus.init.obs;

  NetworkStatus get status => _status.value;

  @override
  void onInit() async {
    if (await Get.find<StorageService>().readTokens() != null)
      Get.offAndToNamed(Routes.PERSONAL);
    super.onInit();
    FlutterNativeSplash.remove();
  }
}
