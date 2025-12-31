library generic;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

Future<void> openWhatsApp(String phone) async {
  final Uri whatsappUrl = Uri.parse("https://wa.me/$phone");

  try {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  } catch (e) {
    print(e);
    throw "No se pudo abrir WhatsApp";
  }
}

Future<void> generatePDF(
    Map<String, dynamic> data, BuildContext context) async {
  final font =
      pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));
  final pdf = pw.Document();

  String id = data['id'] ?? 'N/A';
  String cliente = data['clientName'] ?? 'Cliente Desconocido';
  double total = data['total'] ?? 0.00;
  String contacto = data['contactNumber'] ?? 'N/A';
  String fecha = data['creationDate'] ?? 'N/A';
  List<Map<String, dynamic>> items = (data['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      [];

  String currency = '\$';

  // Fila para los detalles (Contacto, Fecha, etc)
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            child: pw.Text(
              label,
              style: pw.TextStyle(
                  fontSize: 14, font: font, color: PdfColors.grey700),
            ),
          ),
          pw.Flexible(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                  fontSize: 14, font: font, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Tabla para los items
  pw.Widget _buildItemsTable(
      List<Map<String, dynamic>> items, String currency) {
    const List<String> headers = [
      'Descripción',
      'Cantidad',
      'P. Unitario',
      'Total'
    ];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      border: null,
      headerStyle: pw.TextStyle(
          font: font, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      cellAlignment: pw.Alignment.centerRight,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
      },
      data: items.map((item) {
        double totalItem = item['quantity'] * item['unitPrice'];

        return [
          item['description'],
          item['quantity'].toString(),
          '${item['unitPrice']}$currency',
          '${totalItem.toString()}$currency',
        ];
      }).toList(),
    );
  }

  final prefs = await SharedPreferences.getInstance();
  const String imagePathKey = 'footer_image_path';
  final savedPath = prefs.getString(imagePathKey);
  pw.MemoryImage? image;

  if (savedPath != null && savedPath.isNotEmpty) {
    try {
      final imageBytes = await File(savedPath).readAsBytes();
      image = pw.MemoryImage(imageBytes);
    } catch (e) {
      print('Error cargando imagen: $e');
      image = null;
    }
  }

  pw.Widget _buildTotalRow(String label, double amount, String currency,
      {bool isBold = false,
      double fontSize = 14,
      PdfColor color = PdfColors.black}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: fontSize,
              font: font,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Container(
            width: 100,
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              '${amount.toStringAsFixed(2)}$currency',
              style: pw.TextStyle(
                fontSize: fontSize,
                font: font,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GENERACIÓN DE PÁGINA ---
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(15),
      build: (pw.Context context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(30),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Presupuesto - $id',
                style: pw.TextStyle(
                  fontSize: 24,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Cliente:',
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: font,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      cliente,
                      style: pw.TextStyle(
                        fontSize: 26,
                        font: font,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ]),
              pw.Divider(color: PdfColors.grey700, thickness: 1),
              pw.SizedBox(height: 10),
              pw.Text(
                'Detalles:',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey700,
                ),
              ),
              pw.SizedBox(height: 5),
              _buildDetailRow('Número de contacto:', contacto),
              _buildDetailRow('Fecha:', formatDate(DateTime.parse(fecha))),
              pw.SizedBox(height: 20),
              pw.Container(
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(
                              color: PdfColors.black, width: 1.0)))),
              pw.SizedBox(height: 15),
              pw.Text(
                'Ítems:',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey700,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildItemsTable(items, currency),
              pw.SizedBox(height: 20),
              pw.Container(
                  alignment: pw.Alignment.topRight,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Divider(color: PdfColors.black, thickness: 1.5),
                        _buildTotalRow('TOTAL:', total, currency,
                            isBold: true,
                            fontSize: 18,
                            color: PdfColors.blue900),
                      ])),
              pw.Spacer(),
              if (image != null)
                pw.Container(
                  alignment: pw.Alignment.bottomCenter,
                  width: double.infinity,
                  constraints: const pw.BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: pw.Image(
                    image,
                    fit: pw.BoxFit.contain,
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );

  Directory? downloadsDirectory;

  if (Platform.isAndroid) {
    downloadsDirectory = Directory("/storage/emulated/0/Download");

    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }

    final output = File("${downloadsDirectory.path}/presupuesto_$id.pdf");

    await output.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF guardado en: ${output.path}"),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

Future<void> captureAndShareScreenshot(
  ScreenshotController controller,
  BuildContext context,
  String fileName,
) async {
  Uint8List? image = await controller.capture(
    delay: const Duration(milliseconds: 10),
    pixelRatio: MediaQuery.of(context).devicePixelRatio,
  );

  if (image == null) {
    print('Error: La imagen capturada es nula.');
    return;
  }

  final directory = await getTemporaryDirectory();
  final imagePath =
      '${directory.path}/$fileName-${DateTime.now().millisecondsSinceEpoch}.png';
  final imageFile = File(imagePath);

  await imageFile.writeAsBytes(image);

  final xFile = XFile(imagePath);

  final params = ShareParams(
    text: 'Presupuesto por reparación de celular',
    files: [xFile],
  );

  final result = await SharePlus.instance.share(params);

  if (result.status == ShareResultStatus.success) {
    print('Imagen obtenida');
  }
}
