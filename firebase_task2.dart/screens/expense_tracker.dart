import 'package:firebase/firebase_task2.dart/screens/add_edit_screen.dart';
import 'package:firebase/firebase_task2.dart/model/expense_model.dart';
import 'package:firebase/firebase_task2.dart/services/firebase_remote_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _addOrEditExpense({ExpenseModel? expense, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(expense: expense)),
    );

    if (result != null) {
      if (index == null) {
        await FirebaseRemoteDb.addItem(result);
      } else {
        await FirebaseRemoteDb.updateItem(result);
      }
      setState(() {});
    }
  }

  void _deleteExpense(String id) async {
    await FirebaseRemoteDb.deleteItem(id);
    setState(() {});
  }

  void _clearAll() async {
    await FirebaseRemoteDb.clearAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.logout),
        ),
        title: Text("Expense Tracker (Dio)"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _clearAll,
            tooltip: "Clear All",
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseRemoteDb.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final expense = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text("\$${expense.amount.toStringAsFixed(1)}"),
                  ),
                  title: Text(expense.category),
                  subtitle: Text(
                    "${expense.note} - ${(expense.date).toString().split(' ')[0]}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _addOrEditExpense(expense: expense, index: index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExpense(expense.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditExpense(),
      ),
    );
  }
}
