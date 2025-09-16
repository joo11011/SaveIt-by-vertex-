// Refactored lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/installment_model.dart';
import '../core/provider/firestore_service.dart';
import 'base_service.dart';

class FirebaseService extends BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  static const String _installmentsCollection = 'installments';

  Stream<List<InstallmentModel>> getInstallmentsStream() {
    if (_userId == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection(_installmentsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return InstallmentModel(
          id: doc.id,
          installmentName:
          data['installmentName'] ?? data['title'] ?? '',
          dueDate: (data['dueDate'] as Timestamp).toDate(),
          totalAmount: (data['totalAmount'] ?? data['amount'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          notes: data['notes'] ?? '',
          currency: data['currency'] ?? 'USD',
          isPaid: data['isPaid'] ?? (data['status'] == 'paid'),
          paidDate: data['paidDate'] != null
              ? (data['paidDate'] as Timestamp).toDate()
              : null,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          icon: data['icon'] != null
              ? IconData(data['icon'], fontFamily: 'MaterialIcons')
              : null,
          iconColor: data['iconColor'] != null
              ? Color(data['iconColor'] as int)
              : null,
          timeStatus: data['timeStatus'] ?? '',
        );
      }).toList();
    });
  }

  Future<String> addInstallment(InstallmentModel installment) async {
    if (_userId == null) throw Exception('User not authenticated');
    final docRef = await _firestore
        .collection('users')
        .doc(_userId)
        .collection(_installmentsCollection)
        .add({
      'installmentName': installment.installmentName,
      'dueDate': installment.dueDate,
      'totalAmount': installment.totalAmount,
      'category': installment.category,
      'notes': installment.notes,
      'currency': installment.currency,
      'isPaid': installment.isPaid,
      'paidDate': installment.paidDate,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'icon': installment.icon?.codePoint,
      'iconColor': installment.iconColor?.value,
      'timeStatus': installment.timeStatus,
    });
    FirestoreService().updateUserFinancials();
    return docRef.id;
  }

  Future<void> updateInstallmentStatus(String id, bool isPaid) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(_installmentsCollection)
        .doc(id)
        .update({
      'isPaid': isPaid,
      'paidDate': isPaid ? FieldValue.serverTimestamp() : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    FirestoreService().updateUserFinancials();
  }

  Future<void> updateInstallment(InstallmentModel installment) async {
    if (_userId == null) throw Exception('User not authenticated');
    if (installment.id == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(_installmentsCollection)
        .doc(installment.id!)
        .update({
      'installmentName': installment.installmentName,
      'dueDate': installment.dueDate,
      'totalAmount': installment.totalAmount,
      'category': installment.category,
      'notes': installment.notes,
      'currency': installment.currency,
      'isPaid': installment.isPaid,
      'paidDate': installment.paidDate,
      'icon': installment.icon?.codePoint,
      'iconColor': installment.iconColor?.value,
      'timeStatus': installment.timeStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    FirestoreService().updateUserFinancials();
  }

  Future<void> deleteInstallment(String id) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(_installmentsCollection)
        .doc(id)
        .delete();
    FirestoreService().updateUserFinancials();
  }
}