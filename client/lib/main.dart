import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/expenses_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'screens/expenses_list_screen.dart';
import 'theme/wallet_theme.dart';

void main() {
  runApp(const DailyExpenseTrackerApp());
}

class DailyExpenseTrackerApp extends StatelessWidget {
  const DailyExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpensesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeProv, _) => MaterialApp(
          title: 'Daily Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: WalletTheme.light(),
          darkTheme: WalletTheme.dark(),
          themeMode: themeProv.mode,
          home: const ExpensesListScreen(),
        ),
      ),
    );
  }
}
