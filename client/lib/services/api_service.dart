import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/expense.dart';

class ApiService {
  static const _base = baseUrl;

  Future<List<Expense>> getExpenses({
    String? from,
    String? to,
    String? category,
  }) async {
    final q = <String, String>{};
    if (from != null) q['from'] = from;
    if (to != null) q['to'] = to;
    if (category != null && category.isNotEmpty) q['category'] = category;
    final uri = Uri.parse('$_base/api/expenses').replace(queryParameters: q.isEmpty ? null : q);
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception(res.body);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Expense> createExpense({
    required double amount,
    required String category,
    String? note,
    required DateTime date,
  }) async {
    final body = {
      'amount': amount,
      'category': category,
      if (note != null && note.isNotEmpty) 'note': note,
      'date': date.toIso8601String().split('T').first,
    };
    try {
      final res = await http.post(
        Uri.parse('$_base/api/expenses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (res.statusCode != 201) throw Exception(jsonDecode(res.body)['error'] ?? res.body);
      return Expense.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    final res = await http.delete(Uri.parse('$_base/api/expenses/$id'));
    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['error'] ?? res.body);
    }
  }

  Future<Map<String, dynamic>> getMonthlySummary({String? month}) async {
    final q = month != null ? {'month': month} : null;
    final uri = Uri.parse('$_base/api/summary/monthly').replace(queryParameters: q);
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
