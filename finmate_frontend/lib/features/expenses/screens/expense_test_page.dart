import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/expenses/data/expense_api.dart';

class ExpenseTestPage extends StatefulWidget {
  @override
  State<ExpenseTestPage> createState() => _ExpenseTestPageState();
}

class _ExpenseTestPageState extends State<ExpenseTestPage> {
  final ExpenseApi _expenseApi = ExpenseApi();

  void _testExpenses() async {
    try {
      await _expenseApi.createExpense(
        title: "Test Expense",
        amount: 50.0,
        category: "FOOD", // MUST be exact
        date: DateTime.now(),
        customCategoryName: "",
        notes: "Test notes",
      );
      print("✅ Created expense");

      final expenses = await _expenseApi.fetchExpenses();
      print("📦 Expenses: $expenses");
    } catch (e) {
      print("❌ Expense error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Expenses")),
      body: Center(
        child: ElevatedButton(
          onPressed: _testExpenses,
          child: Text("Run Expense Flow"),
        ),
      ),
    );
  }
}
