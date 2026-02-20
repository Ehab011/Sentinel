import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/app_spacing.dart';

class SummaryCard extends StatelessWidget {
  final Map<String, dynamic>? summary;
  final int expenseCount;
  final String? topCategory;
  final double? avgPerDay;

  const SummaryCard({
    super.key,
    this.summary,
    this.expenseCount = 0,
    this.topCategory,
    this.avgPerDay,
  });

  @override
  Widget build(BuildContext context) {
    final total = summary != null ? (summary!['total'] as num?)?.toDouble() ?? 0.0 : 0.0;
    final monthStr = summary?['month'] as String? ?? '';
    final byCategory = summary?['byCategory'] as List<dynamic>? ?? [];
    final formatter = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);

    String? monthTitle;
    if (monthStr.isNotEmpty && monthStr.length >= 7) {
      try {
        final parts = monthStr.split('-');
        final month = int.tryParse(parts[1]) ?? 0;
        final year = int.tryParse(parts[0]) ?? 0;
        final dt = DateTime(year, month);
        monthTitle = DateFormat.yMMM().format(dt);
      } catch (_) {
        monthTitle = monthStr;
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.horizontalPadding,
        AppSpacing.gap16,
        AppSpacing.horizontalPadding,
        AppSpacing.gap8,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.r24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthTitle ?? 'This month',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.gap8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              formatter.format(total),
              key: ValueKey(total),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          if (expenseCount > 0 || topCategory != null || (avgPerDay != null && avgPerDay! > 0)) ...[
            const SizedBox(height: AppSpacing.gap16),
            Row(
              children: [
                if (expenseCount > 0)
                  _StatChip(
                    icon: Icons.receipt_long_outlined,
                    label: '$expenseCount expenses',
                  ),
                if (topCategory != null) ...[
                  const SizedBox(width: AppSpacing.gap8),
                  _StatChip(
                    icon: Icons.category_outlined,
                    label: topCategory!,
                  ),
                ],
                if (avgPerDay != null && avgPerDay! > 0) ...[
                  const SizedBox(width: AppSpacing.gap8),
                  _StatChip(
                    icon: Icons.today_outlined,
                    label: '\$${avgPerDay!.toStringAsFixed(1)}/day',
                  ),
                ],
              ],
            ),
          ],
          if (byCategory.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.gap16),
            Wrap(
              spacing: AppSpacing.gap8,
              runSpacing: AppSpacing.gap8,
              children: byCategory.take(3).map((e) {
                final cat = e['category'] as String? ?? '';
                final tot = (e['total'] as num?)?.toDouble() ?? 0.0;
                return _CategoryChip(
                  category: cat,
                  amount: formatter.format(tot),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.r12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  final String amount;

  const _CategoryChip({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.r12),
      ),
      child: Text(
        '$category: $amount',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
