import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expenses_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../theme/wallet_theme.dart';
import '../ui/widgets/category_pass_row.dart';
import '../ui/widgets/empty_state_wallet.dart';
import '../ui/widgets/loading_skeleton.dart';
import '../ui/widgets/total_pass.dart';
import '../ui/widgets/transaction_row.dart';
import 'add_expense_screen.dart';

const _horizontalPadding = 20.0;

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  List<int> _displayedIds = [];
  final _expenseCache = <int, Expense>{};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpensesProvider>().refresh();
    });
  }

  void _syncAnimatedList(ExpensesProvider prov) {
    final current = prov.expenses.map((e) => e.id).toList();
    if (_displayedIds == current) return;

    if (!_initialized) {
      _displayedIds = current;
      _initialized = true;
      return;
    }

    final currentSet = current.toSet();

    final toRemove = <int>[];
    for (var i = 0; i < _displayedIds.length; i++) {
      if (!currentSet.contains(_displayedIds[i])) toRemove.add(i);
    }
    for (var i = toRemove.length - 1; i >= 0; i--) {
      final idx = toRemove[i];
      final expenseId = _displayedIds[idx];
      final e = _expenseCache[expenseId] ??
          Expense(id: expenseId, amount: 0, category: 'Unknown', date: DateTime.now());
      _expenseCache.remove(expenseId);
      _listKey.currentState?.removeItem(
        idx,
        (context, animation) => _buildRemovingItem(context, e, animation),
      );
      _displayedIds.removeAt(idx);
    }

    final displayedSet = _displayedIds.toSet();
    final toAdd = <MapEntry<int, Expense>>[];
    for (var i = 0; i < prov.expenses.length; i++) {
      if (!displayedSet.contains(prov.expenses[i].id)) {
        toAdd.add(MapEntry(i, prov.expenses[i]));
      }
    }
    toAdd.sort((a, b) => a.key.compareTo(b.key));
    for (final entry in toAdd) {
      final idx = entry.key;
      final e = entry.value;
      _expenseCache[e.id] = e;
      _listKey.currentState?.insertItem(idx);
      _displayedIds.insert(idx, e.id);
    }

    _displayedIds = prov.expenses.map((e) => e.id).toList();
  }

  Widget _buildRemovingItem(
    BuildContext context,
    Expense e,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(_horizontalPadding, 20, _horizontalPadding, 10),
              child: Text(_formatDateHeader(e.date), style: Theme.of(context).textTheme.labelLarge),
            ),
            TransactionRow(
              expense: e,
              onDelete: () async => false,
              onDeleted: null,
            ),
          ],
        ),
      ),
    );
  }

  bool _isDifferentDay(DateTime a, DateTime b) =>
      a.year != b.year || a.month != b.month || a.day != b.day;

  String _formatDateHeader(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) return 'Today';
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day) {
      return 'Yesterday';
    }
    return DateFormat('MMM d').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ExpensesProvider>(
          builder: (context, prov, _) {
            if (prov.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (prov.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(prov.error!),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  prov.clearError();
                }
              });
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: prov.loading && prov.expenses.isEmpty
                  ? KeyedSubtree(key: const ValueKey('loading'), child: const _LoadingView())
                  : KeyedSubtree(key: const ValueKey('content'), child: _buildContent(prov)),
            );
          },
        ),
      ),
      floatingActionButton: Hero(
        tag: 'add_expense',
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => _goToAdd(context),
          backgroundColor: walletAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildContent(ExpensesProvider prov) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncAnimatedList(prov));

    return RefreshIndicator(
      onRefresh: () => prov.refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _WalletHeader(
            monthStr: prov.monthlySummary?['month'],
            onThemeTap: () => context.read<ThemeModeProvider>().cycleNext(),
          ),
          SliverToBoxAdapter(child: _buildTotalPass(prov)),
          SliverToBoxAdapter(child: _buildCategoryRow(prov)),
          if (prov.expenses.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWallet(onAddTap: () => _goToAdd(context)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverAnimatedList(
                key: _listKey,
                initialItemCount: prov.expenses.length,
                itemBuilder: (context, index, animation) {
                  if (index >= prov.expenses.length) return const SizedBox.shrink();
                  final e = prov.expenses[index];
                  final prevDate = index > 0 ? prov.expenses[index - 1].date : null;
                  final showDateHeader =
                      prevDate == null || _isDifferentDay(prevDate, e.date);

                  _expenseCache[e.id] = e;
                  return _AnimatedListItem(
                    animation: animation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showDateHeader)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              _horizontalPadding,
                              20,
                              _horizontalPadding,
                              10,
                            ),
                            child: Text(
                              _formatDateHeader(e.date),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        TransactionRow(
                          expense: e,
                          onDelete: () => prov.deleteExpense(e.id),
                          onDeleted: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Deleted'),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalPass(ExpensesProvider prov) {
    final summary = prov.monthlySummary;
    final monthStr = summary?['month'] as String? ?? prov.currentMonth;
    final expenses = prov.expenses;
    final monthlyCount = monthStr.length >= 7
        ? expenses.where((e) {
            final m = '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
            return m == monthStr;
          }).length
        : expenses.length;
    int daysInMonth = 30;
    if (monthStr.length >= 7) {
      try {
        final parts = monthStr.split('-');
        final y = int.tryParse(parts[0]) ?? DateTime.now().year;
        final m = int.tryParse(parts[1]) ?? DateTime.now().month;
        daysInMonth = DateTime(y, m + 1, 0).day;
      } catch (_) {}
    }
    final total = (summary?['total'] as num?)?.toDouble() ?? 0.0;
    final avgPerDay = daysInMonth > 0 ? total / daysInMonth : 0.0;

    return TotalPass(
      summary: summary,
      transactionCount: monthlyCount,
      avgPerDay: avgPerDay > 0 ? avgPerDay : null,
    );
  }

  Widget _buildCategoryRow(ExpensesProvider prov) {
    final byCategory = prov.monthlySummary?['byCategory'] as List<dynamic>? ?? [];
    if (byCategory.isEmpty) return const SizedBox.shrink();
    return CategoryPassRow(byCategory: byCategory);
  }

  void _goToAdd(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddExpenseScreen(),
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedListItem extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnimatedListItem({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  final String? monthStr;
  final VoidCallback? onThemeTap;

  const _WalletHeader({this.monthStr, this.onThemeTap});

  @override
  Widget build(BuildContext context) {
    String subtitle = 'This month';
    if (monthStr != null && monthStr!.length >= 7) {
      try {
        final p = monthStr!.split('-');
        final m = int.tryParse(p[1]) ?? 0;
        final y = int.tryParse(p[0]) ?? 0;
        subtitle = DateFormat('MMM y').format(DateTime(y, m));
      } catch (_) {}
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(_horizontalPadding, 24, _horizontalPadding, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (onThemeTap != null)
              Consumer<ThemeModeProvider>(
                builder: (context, themeProv, _) => IconButton(
                  onPressed: onThemeTap,
                  icon: Icon(themeProv.icon),
                  tooltip: themeProv.label,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24),
      child: LoadingSkeleton(),
    );
  }
}
