import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/views/login_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => LoginPage());
  }
}
