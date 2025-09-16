import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  var isArabic = false.obs;
  var darkMode = false.obs;
  var notificationsEnabled = true.obs;
  var monthlyBudget = 1000.0.obs;

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // تحميل القيم المخزنة
    isArabic.value = _storage.read('isArabic') ?? false;
    darkMode.value = _storage.read('darkMode') ?? false;
    notificationsEnabled.value = _storage.read('notifications') ?? true;
  }

  void toggleDarkMode(bool value) {
    darkMode.value = value;
    _storage.write('darkMode', value);
  }
}
