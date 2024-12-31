import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/collection.dart';

Future<void> generatePDF(List<Collection> weeklyReport, double totalAmountThisWeek) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('Weekly Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Total Amount Collected This Week: \$${totalAmountThisWeek.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            data: <List<String>>[
              ['Name', 'Amount', 'Date'],
              ...weeklyReport.map((collection) {
                return [
                  collection.name,
                  '\$${collection.amount.toStringAsFixed(2)}',
                  collection.date.toLocal().toString()
                ];
              }),
            ],
            border: pw.TableBorder.all(),
          ),
        ],
      );
    },
  ));

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
