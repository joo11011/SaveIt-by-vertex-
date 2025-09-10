import 'package:final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/nav_controller.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/Profile_screen.dart';
import 'views/Settings_screen.dart';
import 'translations.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthController());
  Get.put(SettingsController());
  Get.put(NavController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: settingsController.darkMode.value
              ? ThemeData.dark()
              : ThemeData.light(),

          translations: AppTranslations(),
          locale: settingsController.isArabic.value
              ? const Locale('ar', 'SA')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),

          home: LoginPage(),
        ));
  }
}
