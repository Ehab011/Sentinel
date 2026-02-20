import 'package:flutter/material.dart';

import '../styles/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddTap;

  const EmptyState({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gap32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.gap24),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.gap8),
            Text(
              'Track your spending by adding your first expense',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.gap32),
            FilledButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add),
              label: const Text('Add your first expense'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
