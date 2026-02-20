import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../services/api_service.dart';

class ExpensesProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Expense> _expenses = [];
  Map<String, dynamic>? _monthlySummary;
  bool _loading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  Map<String, dynamic>? get monthlySummary => _monthlySummary;
  bool get loading => _loading;
  String? get error => _error;

  String get currentMonth {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}';
  }

  Future<void> loadExpenses() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _expenses = await _api.getExpenses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMonthlySummary() async {
    try {
      _monthlySummary = await _api.getMonthlySummary(month: currentMonth);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.wait([loadExpenses(), loadMonthlySummary()]);
  }

  Future<bool> createExpense({
    required double amount,
    required String category,
    String? note,
    required DateTime date,
  }) async {
    _error = null;
    try {
      await _api.createExpense(
        amount: amount,
        category: category,
        note: note,
        date: date,
      );
      await refresh();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExpense(int id) async {
    _error = null;
    try {
      await _api.deleteExpense(id);
      await refresh();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
