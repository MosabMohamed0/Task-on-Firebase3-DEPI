import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase_task2.dart/model/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRemoteDb {
  static final _db = FirebaseFirestore.instance;
  static const String userCollectionName = "users";
  static const String expenseCollection = "expense";

  static Stream<List<ExpenseModel>> getItems() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final expenseCollectionRef = _db
        .collection(userCollectionName)
        .doc(userId)
        .collection(expenseCollection);
    final expenseStream = expenseCollectionRef.snapshots();
    // convert from  Stream<QuerySnapshot> to Stream<List<ExpenseModel>>
    final itemsStream = expenseStream.map((collectionSnapshot) {
      final expenseDocs = collectionSnapshot.docs;
      final items = expenseDocs.map((documentSnapshot) {
        final expenseMap = documentSnapshot.data();
        return ExpenseModel.fromMap(expenseMap);
      });
      return items.toList();
    });
    return itemsStream;
  }

  static Future<void> addItem(ExpenseModel item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final expenseCollectionRef = _db
        .collection(userCollectionName)
        .doc(userId)
        .collection(expenseCollection);
    final expenseStream = expenseCollectionRef.snapshots();
    
    final docRef = expenseCollectionRef
        .doc(); // create a new document reference with auto-generated ID
    item.id = docRef.id; // assign the generated ID to the item
    await docRef.set(item.toMap());
  }

  static Future<void> updateItem(ExpenseModel item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final expenseCollectionRef = _db
        .collection(userCollectionName)
        .doc(userId)
        .collection(expenseCollection);
    final expenseStream = expenseCollectionRef.snapshots();

    await expenseCollectionRef.doc(item.id).update(item.toMap());
  }

  static Future<void> deleteItem(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final expenseCollectionRef = _db
        .collection(userCollectionName)
        .doc(userId)
        .collection(expenseCollection);
    final expenseStream = expenseCollectionRef.snapshots();

    await expenseCollectionRef.doc(id).delete();
  }

  static Future<void> clearAll() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final expenseCollectionRef = _db
        .collection(userCollectionName)
        .doc(userId)
        .collection(expenseCollection);
    final expenseStream = expenseCollectionRef.snapshots();

    final snapshot = await expenseCollectionRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
