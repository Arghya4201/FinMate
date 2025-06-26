import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/expenses/data/expense_api.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'FOOD';
  DateTime _selectedDate = DateTime.now();

  final ExpenseApi _expenseApi = ExpenseApi();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _expenseApi.createExpense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("✅ Expense added"),
      ));
      Navigator.pop(context);
    } catch (e) {
      print("❌ Error adding expense: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("❌ Failed to add expense"),
      ));
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
                validator: (val) => val == null || val.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null
                    ? "Enter valid amount"
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: [
                  'FOOD',
                  'RENT',
                  'UTILITIES',
                  'ENTERTAINMENT',
                  'SAVINGS',
                  'OTHER',
                ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                decoration: InputDecoration(labelText: "Category"),
              ),
              ListTile(
                title: Text("Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Add Expense"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
