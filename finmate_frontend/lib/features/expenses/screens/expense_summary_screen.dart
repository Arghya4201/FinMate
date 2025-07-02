import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finmate_frontend/features/expenses/data/expense_api.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  final ExpenseApi _api = ExpenseApi();
  Map<String, double> categoryTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndSummarize();
  }

  void fetchAndSummarize() async {
  try {
    final expenses = await _api.fetchExpenses();
    print("📦 Expenses fetched: $expenses");

    final totals = <String, double>{};

    for (var expense in expenses) {
      final category = expense['category_display'] ?? expense['category'];
      final rawAmount = expense['amount'];
      final amount = double.tryParse(rawAmount.toString()) ?? 0.0;

      if (category != null && amount > 0) {
        totals[category] = (totals[category] ?? 0) + amount;
      }
    }

    setState(() {
      categoryTotals = totals;
      isLoading = false;
    });
  } catch (e) {
    print("❌ Summary load error: $e");
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Summary")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : categoryTotals.isEmpty
              ? Center(child: Text("No expenses yet"))
              : PieChart(
                  PieChartData(
                    sections: categoryTotals.entries.map((entry) {
                      final color = Colors.primaries[entry.key.hashCode % Colors.primaries.length];
                      return PieChartSectionData(
                        value: entry.value,
                        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
                        color: color,
                        radius: 80,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
