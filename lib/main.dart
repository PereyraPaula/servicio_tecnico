// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:servicio_tecnico/components/AddRowDialog.dart';
import 'package:servicio_tecnico/components/DatePicker.dart';
import 'package:servicio_tecnico/provider/DataProvider.dart';
import 'package:servicio_tecnico/tableview.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: MyApp(),
  ));
}

var myTheme = ThemeData(
    colorSchemeSeed: Color(0xFF03233D),
    scaffoldBackgroundColor: Colors.white);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      title: 'Servicio Tecnico',
      theme: myTheme,
      home: const MyHomePage(title: 'Servicio Técnico'),
      supportedLocales: const [Locale('es')]
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late String date;
  double total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void createPdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();

    // Crear la tabla
    List<pw.TableRow> rows = [];

    // Suponiendo que todas las filas tienen las mismas claves
    if (data.isNotEmpty) {
      // Encabezado
      List<String> headers = ['Cantidad', 'Descripción', 'P.U', 'Total'];
      rows.add(pw.TableRow(
        children: headers
            .map((header) => pw.Padding(
                padding: pw.EdgeInsets.all(4.0),
                child: pw.Text(header,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))))
            .toList(),
      ));

      // Rellenar con los datos
      for (var row in data) {
        rows.add(pw.TableRow(
          children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(4.0),
                child: pw.Text(row['cantidad'] ?? '')),
            pw.Padding(
                padding: pw.EdgeInsets.all(4.0),
                child: pw.Text(row['descripcion'].toString())),
            pw.Padding(
                padding: pw.EdgeInsets.all(4.0),
                child: pw.Text(row['pu'] == null ? "" : row['pu'].toString())),
            pw.Padding(
                padding: pw.EdgeInsets.all(4.0),
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
                    pw.Text(date),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Nombre: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(_nameController.text),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Celular: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(_phoneController.text),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                  },
                  children: rows,
                ),
                pw.SizedBox(height: 20), // Espacio entre la tabla y el total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total: \$',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(total.toStringAsFixed(2)), // Total sumado
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    // Obtener la ruta de Descargas
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final downloadDirectory = Directory(path);
    if (!(await downloadDirectory.exists())) {
      await downloadDirectory.create(recursive: true);
    }

    // Crear el archivo PDF en la carpeta de Descargas
    final file = File(
        "${downloadDirectory.path}/$date-${_nameController.text.trim().split(" ").join("_")}.pdf");
    await file.writeAsBytes(await pdf.save());

    // print("PDF guardado en: ${file.path}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("PDF guardado en: ${file.path}"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      final data = dataProvider.data;
      total = context.read<DataProvider>().total;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fecha",
                        style: TextStyle(fontSize: 16),
                      ),
                      DatePicker(
                        onAdd: (dateSelected) {
                          date = dateSelected;
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Nombre",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          controller: _nameController,
                          focusNode: FocusNode(canRequestFocus: false),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "",
                            isDense: true, 
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Celular",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                            controller: _phoneController,
                            focusNode: FocusNode(canRequestFocus: false),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "",
                              isDense: true,
                            ),
                            keyboardType: TextInputType.phone),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddRowDialog(
                                onAdd: (data) {
                                  context.read<DataProvider>().addItem(data);
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar fila'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Tableview()));
                        },
                        label: const Text('Ver tabla'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'Cantidad de registros: ${context.read<DataProvider>().quantity}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Compartir',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          createPdf(data);
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Como PDF'),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white)),
                      ),
                      /* ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.image),
                        label: const Text('Como Imagen'),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blueAccent),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white)),
                      ), */
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
