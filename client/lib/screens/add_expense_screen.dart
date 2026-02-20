import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/expenses_provider.dart';
import '../theme/wallet_theme.dart';

const _categories = ['Food', 'Transport', 'Bills', 'Shopping', 'Other'];
const _horizontalPadding = 20.0;
const _cardRadius = 26.0;

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _category = 'Food';
  DateTime _date = DateTime.now();
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _submitting = true);
    final prov = context.read<ExpensesProvider>();
    final success = await prov.createExpense(
      amount: amount,
      category: _category,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      date: _date,
    );
    setState(() => _submitting = false);

    if (!mounted) return;
    if (success) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense added'),
          backgroundColor: walletAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prov.error ?? 'Failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = DateFormat('MMM d, y').format(_date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(_horizontalPadding),
          children: [
            const SizedBox(height: 8),
            Hero(
              tag: 'add_expense',
              child: _AmountPass(
                controller: _amountController,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 24),
            _CategoryPassSelector(
              selected: _category,
              onSelected: (c) => setState(() => _category = c),
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _NotePass(
              controller: _noteController,
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _DatePass(
              dateStr: dateStr,
              onTap: _pickDate,
              isDark: isDark,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_horizontalPadding),
          child: _ScaleOnPressButton(
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: walletAccent,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _submitting
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Add Expense'),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountPass extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;

  const _AmountPass({required this.controller, required this.isDark});

  @override
  State<_AmountPass> createState() => _AmountPassState();
}

class _AmountPassState extends State<_AmountPass> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isDark ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(_cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(_cardRadius),
        splashColor: (widget.isDark ? darkPrimary : lightPrimary).withValues(alpha: 0.2),
        highlightColor: (widget.isDark ? darkPrimary : lightPrimary).withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(
              color: _isFocused
                  ? walletAccent
                  : (widget.isDark ? darkBorder : lightBorder),
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: widget.isDark ? darkPrimary : lightPrimary,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(
                color: widget.isDark ? darkSecondary : lightSecondary,
              ),
              prefixText: 'EGP ',
              prefixStyle: TextStyle(
                fontSize: 28,
                color: widget.isDark ? darkSecondary : lightSecondary,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final n = double.tryParse(v.trim());
              if (n == null || n <= 0) return 'Must be > 0';
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryPassSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;
  final bool isDark;

  const _CategoryPassSelector({
    required this.selected,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final c = _categories[i];
          final isSelected = selected == c;
          return Material(
            color: isDark ? darkSurface : lightSurface,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onSelected(c),
              borderRadius: BorderRadius.circular(20),
              splashColor: walletAccent.withValues(alpha: 0.25),
              highlightColor: walletAccent.withValues(alpha: 0.12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? walletAccent : (isDark ? darkBorder : lightBorder),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isDark ? darkPrimary : lightPrimary,
                  ),
                ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotePass extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;

  const _NotePass({required this.controller, required this.isDark});

  @override
  State<_NotePass> createState() => _NotePassState();
}

class _NotePassState extends State<_NotePass> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isDark ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(_cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(_cardRadius),
        splashColor: (widget.isDark ? darkPrimary : lightPrimary).withValues(alpha: 0.2),
        highlightColor: (widget.isDark ? darkPrimary : lightPrimary).withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(
              color: _isFocused
                  ? walletAccent
                  : (widget.isDark ? darkBorder : lightBorder),
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Note (optional)',
              hintStyle: TextStyle(color: widget.isDark ? darkSecondary : lightSecondary),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              fillColor: Colors.transparent,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}

class _DatePass extends StatelessWidget {
  final String dateStr;
  final VoidCallback onTap;
  final bool isDark;

  const _DatePass({
    required this.dateStr,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(_cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardRadius),
        splashColor: walletAccent.withValues(alpha: 0.25),
        highlightColor: walletAccent.withValues(alpha: 0.12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cardRadius),
            border: isDark ? Border.all(color: darkBorder) : null,
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: isDark ? darkSecondary : lightSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? darkPrimary : lightPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: isDark ? darkSecondary : lightSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScaleOnPressButton extends StatefulWidget {
  final Widget child;

  const _ScaleOnPressButton({required this.child});

  @override
  State<_ScaleOnPressButton> createState() => _ScaleOnPressButtonState();
}

class _ScaleOnPressButtonState extends State<_ScaleOnPressButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
