import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'controller/settings_controller.dart';
import 'core/provider/firestore_service.dart';
import 'core/provider/currency_provider.dart';
import 'core/provider/user_provider.dart';
import 'view/Settings_screen/widgets/translations.dart';
import 'view/Splash_screen/splash_screen.dart';
import 'view/Home_screen/Home_screen.dart';
import 'view/Log_in_screen/Log_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider()..loadUserData(),
        ),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<CurrencyProvider>(
          create: (_) => CurrencyProvider(),
        ),
      ],
      child: Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          translations: AppTranslations(),
          locale: settingsController.isArabic.value
              ? const Locale('ar', 'SA')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.darkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return const HomeScreen(); // المستخدم مسجل دخول
              }
              return LoginPage(); // المستخدم مش مسجل
            },
          ),
        ),
      ),
    );
  }
}
