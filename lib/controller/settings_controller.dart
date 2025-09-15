import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isArabic = false.obs;
  var darkMode = false.obs;
  var notificationsEnabled = true.obs;
  var monthlyBudget = 1000.0.obs;
}
