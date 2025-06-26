import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/expenses/data/expense_api.dart';
import 'package:finmate_frontend/features/expenses/screens/add_expense_page.dart';

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
        category: "FOOD", // must match Django model choices
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

  void _goToAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddExpensePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Tester")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _testExpenses,
              child: Text("Run Test Expense Flow"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToAddExpense,
              child: Text("Add Expense via Form"),
            ),
          ],
        ),
      ),
    );
  }
}
