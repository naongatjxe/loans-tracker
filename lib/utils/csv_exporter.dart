import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../models/person.dart';
import 'package:intl/intl.dart';

class CsvExporter {
  static Future<String> exportLoansToCsv(List<Person> loans, {String? outputDirPath}) async {
    try {
      // Create CSV data
      List<List<String>> csvData = [
        // Header row
        [
          'Name',
          'NRC',
          'Phone',
          'Loan Amount',
          'Interest Rate (%)',
          'Interest (Term)',
          'Loan Date',
          'Due Date',
          'Status',
          'Total Amount Due',
        ],
      ];

      // Totals
      double totalLoaned = 0.0;
      double totalInterest = 0.0;
      double interestEarned = 0.0;

      // Add loan data
      for (Person loan in loans) {
        final dateFormat = DateFormat('yyyy-MM-dd');
        final currencyFormat = NumberFormat.currency(symbol: 'K ');

        final totalDue = loan.calculateTotalAmount();
        final interestTerm = totalDue - loan.amount;

        csvData.add([
          loan.name,
          loan.nrc,
          loan.phone,
          currencyFormat.format(loan.amount),
          '${loan.interestRate}%',
          currencyFormat.format(interestTerm),
          dateFormat.format(loan.loanDate),
          dateFormat.format(loan.dueDate),
          loan.isPaid ? 'Paid' : 'Active',
          currencyFormat.format(totalDue),
        ]);

        totalLoaned += loan.amount;
        totalInterest += interestTerm;
        if (loan.isPaid) interestEarned += interestTerm;
      }

      // Append an empty row then totals summary rows
      csvData.add([]);
      csvData.add(['Totals', '', '',
        NumberFormat.currency(symbol: 'K ').format(totalLoaned),
        '',
        NumberFormat.currency(symbol: 'K ').format(totalInterest),
        '',
        '',
        '',
        '']);

      csvData.add(['Interest Earned (paid loans)', '', '', '', '', '', '', '', '',
        NumberFormat.currency(symbol: 'K ').format(interestEarned)]);

      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      final fileName = 'loans_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';

      late Directory dest;

      if (outputDirPath != null) {
        dest = Directory(outputDirPath);
      } else {
        // Try common Android downloads paths first
        final androidPaths = ['/storage/emulated/0/Downloads', '/storage/emulated/0/Download'];
        Directory? found;
        for (final p in androidPaths) {
          final d = Directory(p);
          if (await d.exists()) {
            found = d;
            break;
          }
        }

        // Try path_provider's getDownloadsDirectory as a next fallback
        if (found == null) {
          try {
            found = await getDownloadsDirectory();
          } catch (_) {
            // ignore
          }
        }

        // Final fallback to temporary directory
        found ??= await getTemporaryDirectory();

        dest = found;
      }

      final file = File('${dest.path}/$fileName');
      await file.writeAsString(csvString);

      return file.path;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }
}
