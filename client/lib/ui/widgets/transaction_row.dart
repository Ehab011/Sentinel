import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';
import '../../theme/wallet_theme.dart';

const _iconTileSize = 38.0;
const _iconTileRadius = 12.0;
const _horizontalPadding = 20.0;
const _lightSurfaceVariant = Color(0xFFF2F2F7);
const _darkSurfaceVariant = Color(0xFF2C2C2E);

const _categoryIcons = {
  'Food': Icons.restaurant_outlined,
  'Transport': Icons.directions_car_outlined,
  'Bills': Icons.receipt_long_outlined,
  'Shopping': Icons.shopping_bag_outlined,
  'Other': Icons.more_horiz,
};

class TransactionRow extends StatelessWidget {
  final Expense expense;
  final Future<bool> Function() onDelete;
  final VoidCallback? onDeleted;

  const TransactionRow({
    super.key,
    required this.expense,
    required this.onDelete,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);
    final icon = _categoryIcons[expense.category] ?? Icons.receipt_outlined;

    return Slidable(
      key: Key('${expense.id}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            onPressed: (_) => _confirmDelete(context),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: _iconTileSize,
                  height: _iconTileSize,
                  decoration: BoxDecoration(
                    color: isDark ? _darkSurfaceVariant : _lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(_iconTileRadius),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDark ? darkSecondary : lightSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isDark ? darkPrimary : lightPrimary,
                        ),
                      ),
                      if (expense.note != null && expense.note!.isNotEmpty)
                        Text(
                          expense.note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? darkSecondary : lightSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  currencyFormat.format(expense.amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? darkPrimary : lightPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark ? darkBorder : lightBorder,
            indent: _horizontalPadding + _iconTileSize + 16,
            endIndent: _horizontalPadding,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: isDark ? darkSurface : lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete expense?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? darkPrimary : lightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${expense.category}: ${NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2).format(expense.amount)}',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? darkSecondary : lightSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? darkBorder : lightBorder),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(ctx, true);
                      },
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
