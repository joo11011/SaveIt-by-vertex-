import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'home': 'Home',
          'profile': 'Profile',
          'settings': 'Settings',
          'personal_info': 'Personal Information',
          'login_password': 'Login and Password',
          'privacy_security': 'Privacy and Security',
          'delete': 'Delete Account',

          'language': 'Language',
          'dark': 'Dark Mode',
          'notifications': 'Notifications',
          'monthly_budget': 'Monthly Budget',
          'edit_budget': 'Edit Monthly Budget',
          'cancel': 'Cancel',
          'save': 'Save',
          'Name':'Name',
          'City':'City',
          'bio':'bio',
          "Personal Information":"Personal Information",
          ///
          ///sss
          
          'general': 'General',
          'more': 'More',
          'account': 'Account',
          'help_support': 'Help & Support',
          'about': 'About',
          'logout': 'Logout',
          'theme':'theme',
          'light':'light',
          'Personal Information':'Personal Information',

          //

          'If you face any issues, please contact us at:\n\nsupport@saveit.com\n\nWe are happy to help you anytime!':'If you face any issues, please contact us at:\n\nsupport@saveit.com\n\nWe are happy to help you anytime!',
          'SaveIt App\n\nThis application helps you track expenses and manage your budget.\n\nVersion: 1.0.0':'SaveIt App\n\nThis application helps you track expenses and manage your budget.\n\nVersion: 1.0.0'
        
        },




        'ar': {
          'home': 'الرئيسية',
          'profile': 'الملف الشخصي',
          'settings': 'الإعدادات',
          'personal_info': 'المعلومات الشخصية',
          'login_password': 'تسجيل الدخول وكلمة المرور',
          'privacy_security': 'الخصوصية والأمان',
          'delete': 'حذف الحساب',

          'language': 'اللغة',
          'dark': 'الوضع الليلي',
          'notifications': 'الإشعارات',
          'monthly_budget': 'الميزانية الشهرية',
          'edit_budget': 'تعديل الميزانية',
          'cancel': 'إلغاء',
          'save': 'حفظ',
          'Name':'الاسم',
          'City':'المدينة',
          'bio':'الوصف',
          "Personal Information":"المعلومات الشخصية",
           'general': 'عام',
          'more': 'المزيد',
          'account': 'الحساب',
          'help_support': 'المساعدة والدعم',
          'about': 'حول',
          'logout': 'تسجيل الخروج',
          'theme': 'المظهر'
          ,'light':'وضع الاضاءة',
          'Personal Information':'المعلومات الشخصية',
          'If you face any issues, please contact us at:\n\nsupport@saveit.com\n\nWe are happy to help you anytime!':'إذا واجهت أي مشكلة، يرجى التواصل معنا على:\n\nsupport@saveit.com\n\nنحن سعداء بمساعدتك في أي وقت!',
          'SaveIt App\n\nThis application helps you track expenses and manage your budget.\n\nVersion: 1.0.0':'تطبيق SaveIt\n\nهذا التطبيق يساعدك على تتبع المصاريف وإدارة ميزانيتك.\n\nالإصدار: 1.0.0',
        },
      };
}


class AppTranslationsHelper {
  static String of(BuildContext context, String key) {
    return key.tr;
  }
}
