import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  DateTime date;
  double amount;
  String category;
  String note;

  ExpenseModel({
    this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.note,
  });

  // Convert to Map (للسيرفر)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'category': category,
      'note': note,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    final dateData = map['date'];
    DateTime parsedDate;

    if (dateData is Timestamp) {
      parsedDate = dateData.toDate(); // Firestore Timestamp
    } else {
      parsedDate = DateTime.parse(dateData.toString()); // String (fallback)
    }

    return ExpenseModel(
      id: map['id']?.toString(),
      date: parsedDate,
      amount: (map['amount'] as num).toDouble(),
      category: map['category']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
    );
  }
}
