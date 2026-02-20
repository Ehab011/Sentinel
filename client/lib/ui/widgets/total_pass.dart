import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/wallet_theme.dart';

const _horizontalPadding = 20.0;
const _cardRadius = 26.0;

class TotalPass extends StatelessWidget {
  final Map<String, dynamic>? summary;
  final int transactionCount;
  final double? avgPerDay;

  const TotalPass({
    super.key,
    this.summary,
    this.transactionCount = 0,
    this.avgPerDay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = summary != null ? (summary!['total'] as num?)?.toDouble() ?? 0.0 : 0.0;
    final monthStr = summary?['month'] as String? ?? '';
    final currencyFormat = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);
    final formatted = currencyFormat.format(total);
    final numberPart = formatted.replaceFirst(RegExp(r'^EGP\s*'), '');

    String monthLabel = 'This month';
    if (monthStr.length >= 7) {
      try {
        final p = monthStr.split('-');
        final y = int.tryParse(p[0]) ?? DateTime.now().year;
        final m = int.tryParse(p[1]) ?? DateTime.now().month;
        monthLabel = DateFormat('MMM y').format(DateTime(y, m));
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? darkSurface : lightSurface,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
        border: isDark ? Border.all(color: darkBorder, width: 1) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? darkSecondary : lightSecondary,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    )),
                    child: child,
                  ),
                );
              },
              child: RichText(
                key: ValueKey(total),
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: isDark ? darkPrimary : lightPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: 'EGP ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDark ? darkSecondary : lightSecondary,
                      ),
                    ),
                    TextSpan(text: numberPart),
                  ],
                ),
              ),
            ),
            if (transactionCount > 0 || (avgPerDay != null && avgPerDay! > 0)) ...[
              const SizedBox(height: 12),
              Divider(color: isDark ? darkBorder : lightBorder, thickness: 0.5),
              const SizedBox(height: 12),
              Text(
                _buildSubtext(transactionCount, avgPerDay, currencyFormat),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? darkSecondary : lightSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _buildSubtext(int count, double? avg, NumberFormat fmt) {
    final parts = <String>[];
    if (count > 0) {
      parts.add('$count transaction${count == 1 ? '' : 's'}');
    }
    if (avg != null && avg > 0) {
      parts.add('Avg/day ${fmt.format(avg)}');
    }
    return parts.join(' • ');
  }
}
