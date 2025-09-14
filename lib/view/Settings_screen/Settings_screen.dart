import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/settings_controller.dart';
import '../../../controller/nav_controller.dart';
import '../Home_screen/Home_screen.dart';
import '../Profile_screen/Profile_screen.dart';
import '../Log_in_screen/Log_in_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("settings".tr),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "general".tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.language),
              title: Text("language".tr),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    settingsController.isArabic.value
                        ? "arabic".tr
                        : "english".tr,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () => _chooseLanguage(context, settingsController),
            ),

            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text("theme".tr),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    settingsController.darkMode.value ? "dark".tr : "light".tr,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () => _chooseTheme(context, settingsController),
            ),

            SwitchListTile(
              title: Text("notifications".tr),
              value: settingsController.notificationsEnabled.value,
              onChanged: (val) =>
                  settingsController.notificationsEnabled.value = val,
              secondary: const Icon(Icons.notifications),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "more".tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text("help_support".tr),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(() => const HelpSupportPage()),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text("about".tr),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(() => const AboutPage()),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "account".tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  "logout".tr,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
                onPressed: () async {
                  Get.offAll(() => LoginPage());
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: 2, // لأنك في صفحة Settings
          onTap: (index) {
            if (index == 0) Get.offAll(() => const HomeScreen());
            if (index == 1) Get.offAll(() => const ProfilePage());
            if (index == 2) Get.offAll(() => const SettingsPage());
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: "profile".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: "settings".tr,
            ),
          ],
        ),
      ),
    );
  }

  void _chooseLanguage(BuildContext context, SettingsController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("english".tr),
            onTap: () {
              controller.isArabic.value = false;
              Get.updateLocale(const Locale('en', 'US'));
              Get.back();
            },
          ),
          ListTile(
            title: Text("arabic".tr),
            onTap: () {
              controller.isArabic.value = true;
              Get.updateLocale(const Locale('ar', 'SA'));
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _chooseTheme(BuildContext context, SettingsController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("light".tr),
            onTap: () {
              controller.darkMode.value = false;
              Get.changeTheme(ThemeData.light());
              Get.back();
            },
          ),
          ListTile(
            title: Text("dark".tr),
            onTap: () {
              controller.darkMode.value = true;
              Get.changeTheme(ThemeData.dark());
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("help_support".tr),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "If you face any issues, please contact us at:\n\nsupport@saveit.com\n\nWe are happy to help you anytime!"
              .tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// 🔹 About Page
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("about".tr), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "SaveIt App\n\nThis application helps you track expenses and manage your budget.\n\nVersion: 1.0.0"
              .tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
