import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/wallet_theme.dart';

const _cardRadius = 26.0;
const _shimmerLightBase = Color(0xFFE9E9EE);
const _shimmerLightHighlight = Color(0xFFF5F5F7);
const _shimmerDarkBase = Color(0xFF2C2C2E);
const _shimmerDarkHighlight = Color(0xFF3A3A3C);

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? _shimmerDarkBase : _shimmerLightBase;
    final highlightColor = isDark ? _shimmerDarkHighlight : _shimmerLightHighlight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 90,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          _TotalPassSkeleton(isDark: isDark),
          const SizedBox(height: 16),
          _CategoryRowSkeleton(isDark: isDark),
          const SizedBox(height: 24),
          _TransactionSkeleton(isDark: isDark),
          _TransactionSkeleton(isDark: isDark),
          _TransactionSkeleton(isDark: isDark),
        ],
      ),
    );
  }
}

class _TotalPassSkeleton extends StatelessWidget {
  final bool isDark;

  const _TotalPassSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? _shimmerDarkBase : _shimmerLightBase;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkSurface : lightSurface,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: isDark ? Border.all(color: darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 140,
            height: 38,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? darkBorder : lightBorder, thickness: 0.5),
          const SizedBox(height: 12),
          Container(
            width: 180,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRowSkeleton extends StatelessWidget {
  final bool isDark;

  const _CategoryRowSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => Container(
          width: 140,
          decoration: BoxDecoration(
            color: isDark ? darkSurface : lightSurface,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: isDark ? darkBorder : lightBorder),
          ),
        ),
      ),
    );
  }
}

class _TransactionSkeleton extends StatelessWidget {
  final bool isDark;

  const _TransactionSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? _shimmerDarkBase : _shimmerLightBase;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 120,
                  height: 13,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
