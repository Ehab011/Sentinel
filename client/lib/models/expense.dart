class Expense {
  final int id;
  final double amount;
  final String category;
  final String? note;
  final DateTime date;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
