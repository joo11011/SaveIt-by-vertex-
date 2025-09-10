import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/nav_controller.dart';
import 'Profile_screen.dart';
import 'Settings_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final navController = Get.find<NavController>();

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text("SaveIt"),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),

          body: const Center(
            child: Text(
              "Welcome to SaveIt!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            currentIndex: navController.currentIndex.value,
            onTap: (index) {
              navController.changePage(index);
              if (index == 0) Get.offAll(() => const HomePage());
              if (index == 1) Get.offAll(() => const ProfilePage());
              if (index == 2) Get.offAll(() => const SettingsPage());
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        ));
  }
}
