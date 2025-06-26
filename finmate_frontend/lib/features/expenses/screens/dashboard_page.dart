import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/auth/data/auth_api.dart';
import 'package:finmate_frontend/features/auth/screens/login_screen.dart';
import 'expense_list_page.dart';
import 'add_expense_page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExpenseListPage())),
              child: Text("📦 View My Expenses"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddExpensePage())),
              child: Text("➕ Add New Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
