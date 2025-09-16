import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:savelt_app/view/Splash_screen/splash_screen.dart';

import 'firebase_options.dart';
import 'controller/settings_controller.dart';
import 'core/provider/firestore_service.dart';
import 'core/provider/currency_provider.dart';
import 'core/provider/user_provider.dart';
import 'view/Settings_screen/widgets/translations.dart';
import 'view/Home_screen/Home_screen.dart';
import 'view/Log_in_screen/Log_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize GetStorage
    await GetStorage.init();

    // Initialize settings controller
    Get.put(SettingsController());

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          // ... other providers ...
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    // Handle initialization errors
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
          title: 'SaveIt - Personal Finance Manager',
          translations: AppTranslations(),
          locale: settingsController.isArabic.value
              ? const Locale('ar', 'SA')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: settingsController.darkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              if (snapshot.hasError) {
                return _ErrorScreen(error: snapshot.error.toString());
              }

              if (snapshot.hasData) {
                return const HomeScreen();
              }

              return LoginPage();
            },
          ),
        ),
      ),
    );
  }

  /// Build light theme with custom colors
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  /// Build dark theme with custom colors
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

/// Custom splash screen with app branding
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, size: 80, color: Colors.white),
              SizedBox(height: 24),
              Text(
                'SaveIt',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Personal Finance Manager',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error screen for handling initialization errors
class _ErrorScreen extends StatelessWidget {
  final String error;

  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  // You can implement app restart logic here
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
