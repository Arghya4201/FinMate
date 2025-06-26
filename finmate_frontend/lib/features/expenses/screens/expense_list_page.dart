import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/expenses/data/expense_api.dart';

class ExpenseListPage extends StatefulWidget {
  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final ExpenseApi _expenseApi = ExpenseApi();
  List<dynamic> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final expenses = await _expenseApi.fetchExpenses();
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to load expenses")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Expenses")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _expenses.isEmpty
              ? Center(child: Text("No expenses yet."))
              : ListView.builder(
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    final expense = _expenses[index];
                    return ListTile(
                      title: Text(expense['title'] ?? 'Untitled'),
                      subtitle: Text(
                        "${expense['category_display'] ?? expense['category']} • ${expense['date']}",
                      ),
                      trailing: Text("₹${expense['amount']}"),
                    );
                  },
                ),
    );
  }
}
