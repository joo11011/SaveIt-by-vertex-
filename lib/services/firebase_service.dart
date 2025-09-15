import 'package:cloud_firestore/cloud_firestore.dart';
import '../view/Installments_screen/Installments_screen.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name for installments
  static const String _installmentsCollection = 'installments';

  // Get installments stream
  static Stream<List<Installment>> getInstallmentsStream() {
    return _firestore
        .collection(_installmentsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Installment(
              id: doc.id,
              title: data['title'] ?? '',
              dueDate: data['dueDate'] ?? '',
              amount: (data['amount'] ?? 0).toDouble(),
              status: data['status'] ?? 'upcoming',
              icon: IconData(
                data['icon'] ?? Icons.receipt.codePoint,
                fontFamily: 'MaterialIcons',
              ),
              iconColor: Color(data['iconColor'] ?? Colors.grey.value),
              timeStatus: data['timeStatus'] ?? '',
              category: data['category'] ?? '',
              notes: data['notes'] ?? '',
            );
          }).toList();
        });
  }

  // Add new installment
  static Future<String> addInstallment(Installment installment) async {
    final docRef = await _firestore.collection(_installmentsCollection).add({
      'title': installment.title,
      'dueDate': installment.dueDate,
      'amount': installment.amount,
      'status': installment.status,
      'icon': installment.icon.codePoint,
      'iconColor': installment.iconColor.value,
      'timeStatus': installment.timeStatus,
      'category': installment.category,
      'notes': installment.notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Update installment status
  static Future<void> updateInstallmentStatus(
    String id,
    String newStatus,
  ) async {
    final updateData = {
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (newStatus == 'paid') {
      final now = DateTime.now();
      updateData['dueDate'] =
          'Paid on ${now.day}th ${_getMonthName(now.month)}';
      updateData['timeStatus'] = '';
    }

    await _firestore
        .collection(_installmentsCollection)
        .doc(id)
        .update(updateData);
  }

  // Update installment
  static Future<void> updateInstallment(Installment installment) async {
    if (installment.id == null) return;

    await _firestore
        .collection(_installmentsCollection)
        .doc(installment.id!)
        .update({
          'title': installment.title,
          'dueDate': installment.dueDate,
          'amount': installment.amount,
          'status': installment.status,
          'icon': installment.icon.codePoint,
          'iconColor': installment.iconColor.value,
          'timeStatus': installment.timeStatus,
          'category': installment.category,
          'notes': installment.notes,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  // Delete installment
  static Future<void> deleteInstallment(String id) async {
    await _firestore.collection(_installmentsCollection).doc(id).delete();
  }

  // Helper method to get month name
  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
