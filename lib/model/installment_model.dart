import 'package:cloud_firestore/cloud_firestore.dart';

class InstallmentModel {
  final String? id;
  final String installmentName;
  final double totalAmount;
  final DateTime dueDate;
  final String category;
  final String notes;
  final String currency;
  final bool isPaid;
  final DateTime? paidDate;
  final DateTime createdAt;

  InstallmentModel({
    this.id,
    required this.installmentName,
    required this.totalAmount,
    required this.dueDate,
    required this.category,
    required this.notes,
    required this.currency,
    this.isPaid = false,
    this.paidDate,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'installmentName': installmentName,
      'totalAmount': totalAmount,
      'dueDate': Timestamp.fromDate(dueDate),
      'category': category,
      'notes': notes,
      'currency': currency,
      'isPaid': isPaid,
      'paidDate': paidDate != null ? Timestamp.fromDate(paidDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory InstallmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return InstallmentModel(
      id: documentId,
      installmentName: map['installmentName'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      category: map['category'] ?? '',
      notes: map['notes'] ?? '',
      currency: map['currency'] ?? 'SAR',
      isPaid: map['isPaid'] ?? false,
      paidDate: map['paidDate'] != null 
          ? (map['paidDate'] as Timestamp).toDate() 
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  InstallmentModel copyWith({
    String? id,
    String? installmentName,
    double? totalAmount,
    DateTime? dueDate,
    String? category,
    String? notes,
    String? currency,
    bool? isPaid,
    DateTime? paidDate,
    DateTime? createdAt,
  }) {
    return InstallmentModel(
      id: id ?? this.id,
      installmentName: installmentName ?? this.installmentName,
      totalAmount: totalAmount ?? this.totalAmount,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      currency: currency ?? this.currency,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'InstallmentModel(id: $id, installmentName: $installmentName, totalAmount: $totalAmount, dueDate: $dueDate, category: $category, currency: $currency, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstallmentModel &&
        other.id == id &&
        other.installmentName == installmentName &&
        other.totalAmount == totalAmount &&
        other.dueDate == dueDate &&
        other.category == category &&
        other.notes == notes &&
        other.currency == currency &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        installmentName.hashCode ^
        totalAmount.hashCode ^
        dueDate.hashCode ^
        category.hashCode ^
        notes.hashCode ^
        currency.hashCode ^
        isPaid.hashCode;
  }
}