// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'SaveIt_chat_screen/SaveIt_chat_screen.dart';

void main() {
  runApp(const SaveItApp());
}

class SaveItApp extends StatelessWidget {
  const SaveItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaveIt Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF20C659)),
        useMaterial3: true,
      ),
      home: const SaveItChatScreen(),
    );
  }
}
