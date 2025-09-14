import 'package:flutter/material.dart';
import 'package:savelt_app/view/Home_screen/Home_screen.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFE8F5E9),
      ),
    );
  }
}
