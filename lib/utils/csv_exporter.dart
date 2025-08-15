import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/person.dart';
import 'package:intl/intl.dart';

class CsvExporter {
  static Future<void> exportLoansToCsv(List<Person> loans) async {
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
          'Loan Date',
          'Due Date',
          'Status',
          'Total Amount Due',
        ],
      ];

      // Add loan data
      for (Person loan in loans) {
        final dateFormat = DateFormat('yyyy-MM-dd');
        final currencyFormat = NumberFormat.currency(symbol: 'K ');

        csvData.add([
          loan.name,
          loan.nrc,
          loan.phone,
          currencyFormat.format(loan.amount),
          '${loan.interestRate}%',
          dateFormat.format(loan.loanDate),
          dateFormat.format(loan.dueDate),
          loan.isPaid ? 'Paid' : 'Active',
          currencyFormat.format(loan.calculateTotalAmount()),
        ]);
      }

      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final fileName =
          'loans_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory.path}/$fileName');

      // Write CSV to file
      await file.writeAsString(csvString);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Loans Export - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        subject: 'Loan Tracker Export',
      );
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }
}
