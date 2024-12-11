import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:servicio_tecnico/classes/Exports.dart';

void createPdf(BuildContext context, PdfDataWidget widget, ControllersInputs controllers) async {
  final pdf = pw.Document();

  List<pw.TableRow> rows = [];

  if (widget.data.isNotEmpty) {
    // Encabezado
    List<String> headers = ['Cantidad', 'Descripción', 'P.U', 'Total'];
    rows.add(pw.TableRow(
      children: headers
          .map((header) => pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(header,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))))
          .toList(),
    ));

    for (var row in widget.data) {
      rows.add(pw.TableRow(
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(row['cantidad'] ?? '')),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(row['descripcion'].toString())),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(row['pu'] == null ? "" : row['pu'].toString())),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text("\$ ${row['total'].toString()}"))
        ],
      ));
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Fecha: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(widget.date),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Nombre: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(controllers.nameController.text),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Celular: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(controllers.phoneController.text),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                },
                children: rows,
              ),
              pw.SizedBox(height: 20), // Espacio entre la tabla y el total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total: \$',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(widget.total!.toStringAsFixed(2)), // Total sumado
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  final downloadDirectory = Directory(path);
  if (!(await downloadDirectory.exists())) {
    await downloadDirectory.create(recursive: true);
  }

  String nameClientFile = controllers.nameController.text != ""
      ? controllers.nameController.text.trim().split(" ").join("_")
      : 'Unknown';
  final file = File("${downloadDirectory.path}/${widget.date}-$nameClientFile.pdf");
  await file.writeAsBytes(await pdf.save());

  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("PDF guardado en: ${file.path}"),
  ));
}

