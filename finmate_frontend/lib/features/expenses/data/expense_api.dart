import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  Future<void> _addAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<List<dynamic>> fetchExpenses() async {
    await _addAuthHeader();
    final res = await _dio.get('expenses/');
    return res.data;
  }

  Future<void> createExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? customCategoryName,
    String? notes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final res = await _dio.post(
        '/expenses/',
        data: {
          'title': title,
          'amount': amount,
          'category': category,
          'date': date.toIso8601String().split('T')[0], // ✅ Only "YYYY-MM-DD"
          'custom_category_name': customCategoryName ?? '',
          'notes': notes ?? '',
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print("✅ Expense created: ${res.data}");
    } catch (e) {
      print("❌ Error creating expense: $e");

      if (e is DioException && e.response != null) {
        print("❗️Response data: ${e.response?.data}");
      }
    }
  }
}
