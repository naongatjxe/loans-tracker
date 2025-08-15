import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../theme/theme_controller.dart';
import '../utils/loan_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Provider.of<ThemeController>(context);
    final isDark = themeCtrl.mode == ThemeMode.dark;
    final accent = themeCtrl.accent;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),

          // Appearance Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Appearance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Theme Toggle
                  ListTile(
                    leading: const Icon(
                      Icons.palette_outlined,
                      color: Color(0xFF64B5F6),
                    ),
                    title: const Text('Theme'),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildThemeOption(
                              icon: Icons.light_mode_rounded,
                              label: 'Light',
                              isSelected: !isDark,
                              onTap: () {
                                themeCtrl.setMode(ThemeMode.light);
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildThemeOption(
                              icon: Icons.dark_mode_rounded,
                              label: 'Dark',
                              isSelected: isDark,
                              onTap: () {
                                themeCtrl.setMode(ThemeMode.dark);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accent Color',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Accent Colors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        [
                              Colors.blue,
                              Colors.green,
                              Colors.purple,
                              Colors.orange,
                              Colors.red,
                            ]
                            .map(
                              (color) =>
                                  _buildColorOption(color, accent, themeCtrl),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(
                      Icons.file_download,
                      color: Color(0xFF64B5F6),
                    ),
                    title: const Text('Export CSV'),
                    subtitle: const Text('Export all loan data to CSV file'),
                    onTap: () => _exportCsv(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Color(0xFF64B5F6)),
                    title: Text('Loans Tracker'),
                    subtitle: Text('Version: beta 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xFF64B5F6)),
                    title: Text('Developer'),
                    subtitle: Text('Naonga Gondwe'),
                  ),
                  ListTile(
                    leading: Icon(Icons.business, color: Color(0xFF64B5F6)),
                    title: Text('Developer Company'),
                    subtitle: Text('CommandLine'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Provider.of<ThemeController>(context, listen: false).accent
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(
    Color color,
    Color currentAccent,
    ThemeController themeCtrl,
  ) {
    final isSelected = color == currentAccent;

    return GestureDetector(
      onTap: () {
        themeCtrl.setAccent(color);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
            : null,
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    final provider = Provider.of<LoanProvider>(context, listen: false);
    final people = provider.people;
    if (people.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No loans to export')));
      return;
    }

    final header =
        'id,name,nrc,phone,workplace,amount,interestRate,loanDate,dueDate,isPaid\n';

    String safeCsv(String? s) {
      return '"${(s ?? '').replaceAll('"', '""')}"';
    }

    final rows = people
        .map((p) {
          return '${safeCsv(p.id)},${safeCsv(p.name)},${safeCsv(p.nrc)},${safeCsv(p.phone)},${safeCsv(p.workplace)},${p.amount},${p.interestRate},"${p.loanDate.toIso8601String()}","${p.dueDate.toIso8601String()}",${p.isPaid}';
        })
        .join('\n');

    final csv = header + rows;
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Use application support directory so on Android files are saved
      // under context.getFilesDir() (not app_flutter). This matches the
      // FileProvider <files-path> entry and avoids URI root errors.
      final dir = await getApplicationSupportDirectory();
      final fname =
          'loans_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${dir.path}/$fname');
      await file.writeAsString(csv);
      messenger.showSnackBar(
        SnackBar(content: Text('CSV exported: ${file.path}')),
      );
      // Attempt to invoke platform share via MethodChannel (Android implementation)
      try {
        const channel = MethodChannel('loan_tracker/share');
        await channel.invokeMethod('shareFile', {'path': file.path});
      } catch (_) {
        // ignore platform errors; user can still access the file
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }
}
