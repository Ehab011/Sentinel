import 'package:flutter_test/flutter_test.dart';

import 'package:daily_expense_tracker/main.dart';

void main() {
  testWidgets('App shows Expenses title', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyExpenseTrackerApp());
    expect(find.text('Expenses'), findsOneWidget);
  });
}
