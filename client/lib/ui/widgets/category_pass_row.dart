import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/wallet_theme.dart';

const _horizontalPadding = 20.0;
const _cardRadius = 23.0;

class CategoryPassRow extends StatelessWidget {
  final List<dynamic> byCategory;

  const CategoryPassRow({super.key, required this.byCategory});

  @override
  Widget build(BuildContext context) {
    if (byCategory.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
        itemCount: byCategory.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = byCategory[i];
          final cat = e['category'] as String? ?? '';
          final tot = (e['total'] as num?)?.toDouble() ?? 0.0;
          return _TappableCategoryPass(
            isDark: isDark,
            cat: cat,
            formattedAmount: currencyFormat.format(tot),
          );
        },
      ),
    );
  }
}

class _TappableCategoryPass extends StatefulWidget {
  final bool isDark;
  final String cat;
  final String formattedAmount;

  const _TappableCategoryPass({
    required this.isDark,
    required this.cat,
    required this.formattedAmount,
  });

  @override
  State<_TappableCategoryPass> createState() => _TappableCategoryPassState();
}

class _TappableCategoryPassState extends State<_TappableCategoryPass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller.forward();
  }

  void _onTapUp(_) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isDark ? darkSurface : lightSurface,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: widget.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: widget.isDark
                ? Border.all(color: darkBorder, width: 0.5)
                : Border.all(color: lightBorder, width: 0.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: widget.isDark ? darkSecondary : lightSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.formattedAmount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark ? darkPrimary : lightPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
