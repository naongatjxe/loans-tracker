import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/person.dart';
import '../utils/loan_provider.dart';
import '../theme/theme_controller.dart';

class LoanEditPage extends StatefulWidget {
  final Person? person;
  const LoanEditPage({super.key, this.person});

  @override
  State<LoanEditPage> createState() => _LoanEditPageState();
}

class _LoanEditPageState extends State<LoanEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nrcCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _workplaceCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _interestCtrl;
  late DateTime _loanDate;
  late DateTime _dueDate;

  bool get isEditing => widget.person != null;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _nrcCtrl = TextEditingController(text: p?.nrc ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
    _workplaceCtrl = TextEditingController(text: p?.workplace ?? '');
    _amountCtrl = TextEditingController(
      text: p != null ? p.amount.toString() : '',
    );
    _interestCtrl = TextEditingController(
      text: p != null ? p.interestRate.toString() : '8',
    );
    _loanDate = p?.loanDate ?? DateTime.now();
    _dueDate = p?.dueDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nrcCtrl.dispose();
    _phoneCtrl.dispose();
    _workplaceCtrl.dispose();
    _amountCtrl.dispose();
    _interestCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLoanDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _loanDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _loanDate = d);
  }

  Future<void> _pickDueDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: _loanDate,
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _dueDate = d);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<LoanProvider>(context, listen: false);
    final person = Person(
      id: widget.person?.id ?? const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      nrc: _nrcCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      workplace: _workplaceCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      interestRate: double.parse(_interestCtrl.text.trim()),
      loanDate: _loanDate,
      dueDate: _dueDate,
      isPaid: widget.person?.isPaid ?? false,
    );

    if (isEditing) {
      provider.updatePerson(person);
    }

    Navigator.pop(context, person);
  }

  @override
  Widget build(BuildContext context) {
    final accent = Provider.of<ThemeController>(context, listen: false).accent;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Loan' : 'Add New Loan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: Text(isEditing ? 'UPDATE' : 'SAVE'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildSectionHeader(
                icon: Icons.person_rounded,
                title: 'Personal Information',
                delay: 0,
              ),
              const SizedBox(height: 16),

              // Personal Information Cards
              _buildModernTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                delay: 100,
              ),
              const SizedBox(height: 16),

              _buildModernTextField(
                controller: _nrcCtrl,
                label: 'NRC Number',
                icon: Icons.badge_rounded,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                delay: 150,
              ),
              const SizedBox(height: 16),

              _buildModernTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                delay: 200,
              ),
              const SizedBox(height: 16),

              _buildModernTextField(
                controller: _workplaceCtrl,
                label: 'Workplace',
                icon: Icons.business_rounded,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                delay: 250,
              ),

              const SizedBox(height: 32),

              // Loan Information
              _buildSectionHeader(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Loan Details',
                delay: 300,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      controller: _amountCtrl,
                      label: 'Amount (K)',
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return 'Required';
                        final amt = double.tryParse(v!);
                        if (amt == null || amt <= 0) return 'Invalid amount';
                        return null;
                      },
                      delay: 350,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernTextField(
                      controller: _interestCtrl,
                      label: 'Interest Rate (%)',
                      icon: Icons.trending_up_rounded,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return 'Required';
                        final rate = double.tryParse(v!);
                        if (rate == null || rate < 0) return 'Invalid rate';
                        return null;
                      },
                      delay: 400,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Date Section
              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      label: 'Loan Date',
                      date: _loanDate,
                      onTap: _pickLoanDate,
                      icon: Icons.calendar_today_rounded,
                      delay: 450,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateSelector(
                      label: 'Due Date',
                      date: _dueDate,
                      onTap: _pickDueDate,
                      icon: Icons.event_rounded,
                      delay: 500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeController>(
                      context,
                      listen: false,
                    ).accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Provider.of<ThemeController>(
                      context,
                      listen: false,
                    ).accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                validator: validator,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: Icon(icon),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Provider.of<ThemeController>(
                        context,
                        listen: false,
                      ).accent,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required IconData icon,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: Provider.of<ThemeController>(
                                context,
                                listen: false,
                              ).accent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d, yyyy').format(date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
