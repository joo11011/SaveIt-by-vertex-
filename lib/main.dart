import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savelt_app/core/provider/user_provider.dart';
import 'package:savelt_app/firebase_options.dart';
import 'package:savelt_app/view/Home_screen/Home_screen.dart';
import 'package:savelt_app/view/Log_in_screen/Log_in_screen.dart';
import 'core/provider/firestore_service.dart';
import 'core/provider/currency_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //عشان المستخدم لو سجل خروجه و رجع دخل يلاقي كل اللي كاتبه في التطبيق كله
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider()..loadUserData(),
        ),
        
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<CurrencyProvider>(
          create: (_) => CurrencyProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        //  هنا بنحدد الشاشة حسب حالة تسجيل الدخول
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return const HomeScreen(); // لو المستخدم مسجل دخول
            }
            return LoginPage(); // لو مش مسجل
          },
        ),
      ),
    );
  }
}
