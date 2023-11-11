import 'package:auth/app/data/network_statuses/network_status.dart';
import 'package:auth/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                Colors.lightBlue,
              )),
              onPressed: () => Get.offAndToNamed(Routes.HOME),
              child: const Text(
                "НА ГЛАВНУЮ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Text("Логин", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 45),
            SizedBox(
              width: Get.width * 0.8,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Имя пользователя",
                ),
                controller: controller.nameController,
                style: const TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: Get.width * 0.8,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Пароль",
                ),
                controller: controller.passController,
                style: const TextStyle(fontSize: 26),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 45),
            SizedBox(
              height: 50,
              width: Get.width * 0.8,
              child: Obx(
                () => controller.status == NetworkStatus.loading
                    ? const ElevatedButton(
                        onPressed: null,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () => controller.login(),
                        child:
                            const Text("Войти", style: TextStyle(fontSize: 24)),
                      ),
              ),
            ),
            TextButton(
                onPressed: () => Get.offAndToNamed(Routes.REG),
                child: const Text("Нет аккаунта? Создайте!"))
          ],
        ),
      ),
    );
  }
}
