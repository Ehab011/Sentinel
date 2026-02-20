import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';
import '../styles/app_spacing.dart';

const _categoryIcons = {
  'Food': Icons.restaurant_outlined,
  'Transport': Icons.directions_car_outlined,
  'Bills': Icons.receipt_long_outlined,
  'Shopping': Icons.shopping_bag_outlined,
  'Other': Icons.more_horiz,
};

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final Future<bool> Function() onDelete;
  final VoidCallback? onDeleted;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onDelete,
    this.onDeleted,
  });

  IconData get _categoryIcon => _categoryIcons[expense.category] ?? Icons.receipt_outlined;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.MMMd();
    final timeFormat = DateFormat.jm();
    final currencyFormat = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalPadding,
        vertical: AppSpacing.gap4,
      ),
      child: Slidable(
        key: Key('${expense.id}'),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: BorderRadius.circular(AppSpacing.r16),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.r16),
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(AppSpacing.r16),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gap16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppSpacing.r12),
                    ),
                    child: Icon(_categoryIcon, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.gap16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.category,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (expense.note != null && expense.note!.isNotEmpty)
                          Text(
                            expense.note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          Text(
                            '${dateFormat.format(expense.date)} • ${timeFormat.format(expense.date)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormat.format(expense.amount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.r24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete expense?',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.gap8),
              Text(
                '${expense.category}: ${NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2).format(expense.amount)}',
                style: Theme.of(ctx).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.gap24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.gap12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(ctx).colorScheme.error,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) {
      final success = await onDelete();
      if (context.mounted && success) onDeleted?.call();
    }
  }
}
