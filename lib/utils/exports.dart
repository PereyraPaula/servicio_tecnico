import 'dart:typed_data';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:servicio_tecnico/classes/Exports.dart';

void createPdf(BuildContext context, StructureData widget,
    ControllersInputs controllers) async {
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
                  pw.Text(widget.total ?? ''), // Total sumado
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Directory downloadDirectory = await getPathDownloads();

  String nameClientFile = controllers.nameController.text != ""
      ? controllers.nameController.text.trim().split(" ").join("_")
      : 'Unknown';
  final file =
      File("${downloadDirectory.path}/${widget.date}-$nameClientFile.pdf");
  await file.writeAsBytes(await pdf.save());

  showNotification(context, file, "PDF");
}

void createImage(BuildContext context, ControllersInputs inputControllers,
    ScreenshotController screenshotController, StructureData w) async {
  Screenshot widget = buildWidget(screenshotController, w, inputControllers);

  await screenshotController
      .captureFromLongWidget(widget)
      .then((Uint8List? image) async {
    saveImage(context, screenshotController, image, inputControllers, w);
  }).catchError((error) {
    print(error);
  });
}

void saveImage(BuildContext context, ScreenshotController screenshotController,
    Uint8List? image, ControllersInputs controllers, StructureData data) async {
  print(image);
  if (image != null) {
    Directory downloadDirectory = await getPathDownloads();
    final imagePath = File(
        '${downloadDirectory.path}/${data.date}-${controllers.nameController.text}.jpg');
    await imagePath.writeAsBytes(image);
    showNotification(context, imagePath, "Image");
  }
}

void showNotification(BuildContext context, File file, String type) {
  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$type guardado en: ${file.path}"),
  ));
}

String formattedResultMoney(result) {
  String formattedResult = result.toStringAsFixed(2).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );

  return formattedResult;
}

Future<Directory> getPathDownloads() async {
  String path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  final downloadDirectory = Directory(path);
  if (!(await downloadDirectory.exists())) {
    await downloadDirectory.create(recursive: true);
  }
  return downloadDirectory;
}

Screenshot buildWidget(ScreenshotController controller, StructureData info,
    ControllersInputs inputControllers) {
  return Screenshot(
    controller: controller,
    child: Container(
      padding: const EdgeInsets.all(30.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Encabezado
          Text("Fecha: ${info.date ?? '-'}",
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text("Nombre: ${inputControllers.nameController.text ?? '-'}",
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text("Celular: ${inputControllers.phoneController.text ?? '-'}",
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          const SizedBox(height: 20),
          // Tabla
          DataTable(
            columns: const [
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Descripción')),
              DataColumn(label: Text('PU')),
              DataColumn(label: Text('Total')),
            ],
            rows: info.data
                .map(
                  (item) => DataRow(cells: [
                    DataCell(Text(item['cantidad'] ?? '')),
                    DataCell(Text(item['descripcion'].toString())),
                    DataCell(
                        Text(item['pu'] == null ? "" : item['pu'].toString())),
                    DataCell(Text("\$ ${item['total'].toString()}")),
                  ]),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total: \$ ${info.total}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    ),
  );
}
