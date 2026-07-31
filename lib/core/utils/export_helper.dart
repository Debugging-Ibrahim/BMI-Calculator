import 'package:flutter/material.dart' show debugPrint;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExportHelper {
  static pw.Widget _buildHourglassLogo() {
    return pw.Container(
      width: 18,
      height: 22,
      margin: const pw.EdgeInsets.only(right: 8),
      child: pw.CustomPaint(
        painter: (PdfGraphics canvas, PdfPoint size) {
          final color = PdfColor.fromHex("#7ca613");
          
          canvas.setColor(color);
          canvas.setLineWidth(1.2);
          
          // Draw top horizontal line
          canvas.moveTo(0, size.y);
          canvas.lineTo(size.x, size.y);
          canvas.strokePath();
          
          // Draw bottom horizontal line
          canvas.moveTo(0, 0);
          canvas.lineTo(size.x, 0);
          canvas.strokePath();
          
          // Draw the hourglass body path
          canvas.moveTo(1.5, size.y - 1.5);
          canvas.lineTo(size.x - 1.5, size.y - 1.5);
          canvas.lineTo(size.x / 2, size.y / 2);
          canvas.lineTo(size.x - 1.5, 1.5);
          canvas.lineTo(1.5, 1.5);
          canvas.lineTo(size.x / 2, size.y / 2);
          canvas.closePath();
          canvas.strokePath();
        },
      ),
    );
  }

  static Future<void> shareSingleResultAsText({
    required double bmi,
    required String category,
    required String height,
    required String weight,
    required String date,
    double? targetCalories,
  }) async {
    final String shareText = "My BMI Calculation Report:\n"
        "- BMI: ${bmi.toStringAsFixed(1)} ($category)\n"
        "- Height: ${height}cm\n"
        "- Weight: ${weight}kg\n"
        "- Calculated on: $date\n"
        "${targetCalories != null ? '- Recommended Target: ${targetCalories.toStringAsFixed(0)} kcal/day\n' : ''}"
        "Generated via BMI Calculator app.";

    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: "My BMI Calculation",
      ),
    );
  }

  static Future<void> shareFullHistoryAsText(List<Map<dynamic, dynamic>> history) async {
    if (history.isEmpty) return;

    final StringBuffer buffer = StringBuffer();
    buffer.writeln("My BMI Calculation History Report:");
    buffer.writeln("=================================");
    
    for (var entry in history) {
      final double bmi = entry['value'] ?? 0.0;
      final String cat = entry['category'] ?? 'N/A';
      final String h = entry['height'] ?? '0';
      final String w = entry['weight'] ?? '0';
      final String rawDate = entry['date'] ?? '';
      
      String formattedD = 'N/A';
      if (rawDate.isNotEmpty) {
        final parsed = DateTime.tryParse(rawDate);
        if (parsed != null) {
          formattedD = "${parsed.day}/${parsed.month}/${parsed.year}";
        }
      }
      
      buffer.writeln("- $formattedD: ${bmi.toStringAsFixed(1)} ($cat) | ${h}cm | ${w}kg");
    }
    
    await SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: "My BMI History Report",
      ),
    );
  }

  static Future<void> exportSinglePdf({
    required double bmi,
    required String category,
    required String height,
    required String weight,
    required String date,
    double? bmr,
    double? tdee,
    double? targetCalories,
    required List<Map<String, String>> recommendations,
  }) async {
    final pdf = pw.Document();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    String username = "User";
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          username = doc.data()?['name'] ?? "User";
        }
      } catch (e) {
        debugPrint("Error loading username: $e");
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          _buildHourglassLogo(),
                          pw.Text(
                            "BMI Calculator",
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex("#7ca613"),
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        "Personal Health Report",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColor.fromHex("#7ca613")),
              pw.SizedBox(height: 15),

              // Personalized Metadata Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "User: $username",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.Text(
                    "Report Date: $date",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),

              // BMI Card
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#f7f9fa"),
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColor.fromHex("#E0E0E0")),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "CLASSIFICATION",
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          category,
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#7ca613"),
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      bmi.toStringAsFixed(1),
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#151615"),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Body measurements
              pw.Text("Measurements", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Height")),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("$height cm")),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Weight")),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("$weight kg")),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Energy Estimations
              pw.Text("Metabolic Estimations", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  if (bmr != null)
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("BMR (Basal Metabolic Rate)")),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${bmr.toStringAsFixed(0)} kcal/day")),
                      ],
                    ),
                  if (tdee != null)
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("TDEE (Total Daily Energy Expenditure)")),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${tdee.toStringAsFixed(0)} kcal/day")),
                      ],
                    ),
                  if (targetCalories != null)
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Target Calories (Recommended)")),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${targetCalories.toStringAsFixed(0)} kcal/day", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Recommendations
              if (recommendations.isNotEmpty) ...[
                pw.Text("Guidelines", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                ...recommendations.map((rec) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Bullet(
                      text: "${rec['header']!} ${rec['desc']!}",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'BMI_Report_${date.replaceAll("/", "_").replaceAll(":", "_").replaceAll(" ", "_")}.pdf',
    );
  }

  static Future<void> exportFullHistoryPdf(List<Map<dynamic, dynamic>> history) async {
    if (history.isEmpty) return;

    final pdf = pw.Document();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    String username = "User";
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          username = doc.data()?['name'] ?? "User";
        }
      } catch (e) {
        debugPrint("Error loading username: $e");
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        _buildHourglassLogo(),
                        pw.Text(
                          "BMI Calculator",
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#7ca613"),
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      "Health History Summary Report",
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 1, color: PdfColor.fromHex("#7ca613")),
            pw.SizedBox(height: 15),

            // Metadata
            pw.Text("User: $username", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text("Export Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", style: const pw.TextStyle(fontSize: 10)),
            pw.Text("Total Calculations: ${history.length}", style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // Table
            pw.Table(
              border: pw.TableBorder.symmetric(inside: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
              columnWidths: {
                0: const pw.FlexColumnWidth(2), // Date
                1: const pw.FlexColumnWidth(1), // BMI
                2: const pw.FlexColumnWidth(1.8), // Category
                3: const pw.FlexColumnWidth(1.2), // Height
                4: const pw.FlexColumnWidth(1.2), // Weight
                5: const pw.FlexColumnWidth(1.2), // Target Cal
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex("#7ca613"),
                  ),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Date", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("BMI", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Category", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Height", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Weight", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Target", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9))),
                  ],
                ),
                // Data Rows
                ...history.map((entry) {
                  final double bmiVal = entry['value'] ?? 0.0;
                  final String cat = entry['category'] ?? 'N/A';
                  final String h = entry['height'] ?? '0';
                  final String w = entry['weight'] ?? '0';
                  final String rawDate = entry['date'] ?? '';
                  final double? target = entry['targetCalories'];

                  String formattedD = 'N/A';
                  if (rawDate.isNotEmpty) {
                    final parsed = DateTime.tryParse(rawDate);
                    if (parsed != null) {
                      formattedD = "${parsed.day}/${parsed.month}/${parsed.year}";
                    }
                  }

                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(formattedD, style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(bmiVal.toStringAsFixed(1), style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(cat, style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("${h}cm", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("${w}kg", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(target != null ? "${target.toStringAsFixed(0)} kcal" : "N/A", style: const pw.TextStyle(fontSize: 8))),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'BMI_History_Report.pdf',
    );
  }
}
