import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../styles/app_spacing.dart';

class SkeletonSummaryCard extends StatelessWidget {
  const SkeletonSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade600 : Colors.grey.shade100;

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
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSpacing.gap12),
            Container(
              width: 160,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: AppSpacing.gap16),
            Row(
              children: List.generate(
                3,
                (_) => Container(
                  width: 80,
                  height: 28,
                  margin: const EdgeInsets.only(right: AppSpacing.gap8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.r12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonExpenseList extends StatelessWidget {
  final int itemCount;

  const SkeletonExpenseList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade600 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontalPadding),
        itemCount: itemCount,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.gap8),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.r16),
            ),
          ),
        ),
      ),
    );
  }
}
