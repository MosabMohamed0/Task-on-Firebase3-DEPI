import 'package:firebase/firebase_task2.dart/model/expense_model.dart';
import 'package:flutter/material.dart';

DateTime convertTimestampToDateTime(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

int convertDateTimeToTimestamp(DateTime date) {
  return date.millisecondsSinceEpoch ~/ 1000;
}

class AddEditScreen extends StatefulWidget {
  final ExpenseModel? expense;

  const AddEditScreen({super.key, this.expense});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  String _category = "Food";
  DateTime _date = DateTime.now();
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? "",
    );
    _noteController = TextEditingController(text: widget.expense?.note ?? "");
    _category = widget.expense?.category ?? "Food";
    _date = widget.expense?.date ?? DateTime.now();
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = ExpenseModel(
        id: widget.expense?.id,
        date: _date,
        amount: double.tryParse(_amountController.text) ?? 0,
        category: _category,
        note: _noteController.text,
      );
      Navigator.pop(context, expense);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? "Add Expense" : "Edit Expense"),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: _saveExpense)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter amount" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: "Category"),
                items: ["Food", "Transport", "Shopping", "Other"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: "Note"),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Date: ${_date.toString().split(' ')[0]}"),
                  Spacer(),
                  TextButton(child: Text("Pick Date"), onPressed: _pickDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
