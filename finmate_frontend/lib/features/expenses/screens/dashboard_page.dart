import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/auth/data/auth_api.dart';
import 'package:finmate_frontend/features/auth/screens/login_screen.dart';
import 'expense_list_page.dart';
import 'add_expense_page.dart';
import 'expense_summary_screen.dart'; // Make sure this file exists

class DashboardPage extends StatelessWidget {
  final AuthApi _authApi = AuthApi();

  void _logout(BuildContext context) async {
    await _authApi.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: "Logout",
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.list),
                label: Text("📦 View My Expenses"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExpenseListPage()),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("➕ Add New Expense"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddExpensePage()),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.pie_chart),
                label: Text("📊 Expense Summary"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExpenseSummaryScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
