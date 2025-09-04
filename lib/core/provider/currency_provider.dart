import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedCurrency = 'SAR';
  bool _isLoading = false;

  final Map<String, Map<String, String>> _currencyData = {
    'SAR': {
      'symbol': 'SAR',
      'name': 'Saudi Riyal',
      'flag': '🇸🇦',
    },
    'USD': {
      'symbol': '\$',
      'name': 'US Dollar',
      'flag': '🇺🇸',
    },
    'EUR': {
      'symbol': '€',
      'name': 'Euro',
      'flag': '🇪🇺',
    },
    'EGP': {
      'symbol': 'EGP',
      'name': 'Egyptian Pound',
      'flag': '🇪🇬',
    },
    'GBP': {
      'symbol': '£',
      'name': 'British Pound',
      'flag': '🇬🇧',
    },
    'JPY': {
      'symbol': '¥',
      'name': 'Japanese Yen',
      'flag': '🇯🇵',
    },
  };

  // Getters
  String get selectedCurrency => _selectedCurrency;
  String get currencySymbol => _currencyData[_selectedCurrency]?['symbol'] ?? 'SAR';
  String get currencyName => _currencyData[_selectedCurrency]?['name'] ?? 'Saudi Riyal';
  String get currencyFlag => _currencyData[_selectedCurrency]?['flag'] ?? '🇸🇦';
  bool get isLoading => _isLoading;

  List<String> get availableCurrencies => _currencyData.keys.toList();

  Map<String, String> getCurrencyInfo(String currencyCode) {
    return _currencyData[currencyCode] ?? _currencyData['SAR']!;
  }

  // Initialize currency from Firebase
  Future<void> initializeCurrency() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = _authService.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          String savedCurrency = userData['currency'] ?? 'SAR';
          if (_currencyData.containsKey(savedCurrency)) {
            _selectedCurrency = savedCurrency;
          }
        }
      }
    } catch (e) {
      debugPrint('Initialize currency error: $e');
      _selectedCurrency = 'SAR'; // Fallback to default
    }

    _isLoading = false;
    notifyListeners();
  }

  // Set currency and save to Firebase
  Future<bool> setCurrency(String currency) async {
    if (!_currencyData.containsKey(currency)) return false;

    _isLoading = true;
    notifyListeners();

    try {
      String _ = _selectedCurrency;
      _selectedCurrency = currency;

      // Save to Firebase if user is authenticated
      User? user = _authService.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'currency': currency,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Set currency error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Format amount with current currency
  String formatAmount(double amount, {bool showSymbol = true, bool showCode = false}) {
    if (amount.isNaN || amount.isInfinite) {
      return showSymbol ? '$currencySymbol 0.00' : '0.00';
    }

    String formattedAmount = amount.toStringAsFixed(2);

    // Add thousand separators for better readability
    if (amount >= 1000) {
      final parts = formattedAmount.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '00';

      String formatted = '';
      for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
        if (count > 0 && count % 3 == 0) {
          formatted = ',$formatted';
        }
        formatted = integerPart[i] + formatted;
      }
      formattedAmount = '$formatted.$decimalPart';
    }

    if (showSymbol && showCode) {
      return '$currencySymbol $formattedAmount $_selectedCurrency';
    } else if (showSymbol) {
      return '$currencySymbol $formattedAmount';
    } else if (showCode) {
      return '$formattedAmount $_selectedCurrency';
    } else {
      return formattedAmount;
    }
  }

  // Format amount with specific currency
  String formatAmountWithCurrency(double amount, String currencyCode) {
    if (amount.isNaN || amount.isInfinite) return '0.00';

    String symbol = _currencyData[currencyCode]?['symbol'] ?? currencyCode;
    return '$symbol ${amount.toStringAsFixed(2)}';
  }

  // Get formatted currency display for dropdown
  String getCurrencyDisplay(String currencyCode) {
    Map<String, String> info = getCurrencyInfo(currencyCode);
    return '${info['flag']} $currencyCode - ${info['name']}';
  }

  // Listen to user currency changes in real-time
  Stream<String> get currencyStream {
    User? user = _authService.currentUser;
    if (user == null) return Stream.value('SAR');

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String currency = data['currency'] ?? 'SAR';
        if (_selectedCurrency != currency && _currencyData.containsKey(currency)) {
          _selectedCurrency = currency;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
        }
        return currency;
      }
      return 'SAR';
    });
  }

  // Convert amount between currencies (simplified - in real app you'd use exchange rates API)
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (amount.isNaN || amount.isInfinite) return 0.0;

    // This is a simplified conversion - in a real app, you'd integrate with a currency exchange API
    // For demo purposes, using fixed rates
    Map<String, double> rates = {
      'SAR': 1.0,
      'USD': 0.27,
      'EUR': 0.24,
      'EGP': 8.25,
      'GBP': 0.21,
      'JPY': 40.0,
    };

    double fromRate = rates[fromCurrency] ?? 1.0;
    double toRate = rates[toCurrency] ?? 1.0;

    if (fromRate == 0) return 0.0;

    double baseAmount = amount / fromRate;
    return baseAmount * toRate;
  }

  // Validate currency code
  bool isValidCurrency(String currencyCode) {
    return _currencyData.containsKey(currencyCode);
  }

  // Reset to default currency
  Future<void> resetToDefault() async {
    await setCurrency('SAR');
  }

  // Get currency symbol without amount formatting
  String getSymbolOnly(String currencyCode) {
    return _currencyData[currencyCode]?['symbol'] ?? currencyCode;
  }

  // Check if amount is valid
  bool isValidAmount(double amount) {
    return !amount.isNaN && !amount.isInfinite && amount >= 0;
  }
}