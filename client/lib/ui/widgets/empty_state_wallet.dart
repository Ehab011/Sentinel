import 'package:flutter/material.dart';

import '../../theme/wallet_theme.dart';

class EmptyStateWallet extends StatelessWidget {
  final VoidCallback onAddTap;

  const EmptyStateWallet({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No expenses yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDark ? darkPrimary : lightPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add an expense to start tracking',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: isDark ? darkSecondary : lightSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onAddTap,
              style: FilledButton.styleFrom(
                backgroundColor: walletAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
