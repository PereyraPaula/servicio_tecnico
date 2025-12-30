import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:servicio_tecnico/utils/generics.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ViewBudget extends StatelessWidget {
  final Map<String, dynamic>? data;
  final ScreenshotController screenshotController;

  const ViewBudget({
    Key? key,
    required this.data,
    required this.screenshotController,
  }) : super(key: key);

  String _getSafeString(String key, {String defaultValue = ''}) {
    if (data == null || data!.isEmpty) return defaultValue;
    final value = data![key];
    return value?.toString().trim() ?? defaultValue;
  }

  Widget _buildDetailRow(String label, dynamic value) {
    String displayValue;

    if (value == null) {
      displayValue = 'N/A';
    } else if (value is String) {
      displayValue = value.isNotEmpty ? value : 'N/A';
    } else if (value is num) {
      displayValue = value.toString();
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            displayValue,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle([Color? foregroundColor]) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: foregroundColor ?? Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String client = _getSafeString('clientName',
        defaultValue: 'No se pudo obtener el nombre');
    final String total = _getSafeString('total', defaultValue: '0,00\$');
    final String contact = _getSafeString('contactNumber');
    final String creationDate =
        formatDate(DateTime.parse(_getSafeString('creationDate')));

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      body: Center(
        child: Container(
          width: 350, // Ancho fijo para simular el diálogo/pantalla
          decoration: decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Screenshot(
                controller: screenshotController,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Presupuesto',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Cliente: $client",
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              "Total: $total\$",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3D53),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Encabezado DETALLES
                            const Text(
                              'DETALLES',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),

                            _buildDetailRow('Contacto', contact),
                            _buildDetailRow('Fecha', creationDate),
                            const Divider(height: 20),

                            const Text(
                              'ITEMS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),

                            if (data == null ||
                                data!['items'] == null ||
                                data!['items'].isEmpty)
                              const Text("-")
                            else
                              ...data!['items'].map<Widget>((item) {
                                return _buildDetailRow(
                                  "${item["description"] ?? "N/A"} (${item["quantity"]})",
                                  "${item["unitPrice"] ?? "N/A"} \$",
                                );
                              }).toList(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => captureAndShareScreenshot(
                          screenshotController,
                          context,
                          client,
                        ),
                        icon: const Icon(Icons.image),
                        label: const Text('Enviar como imagen'),
                        style: _buttonStyle(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => {
                          if (data != null ||
                              data!['items'] != null ||
                              data!['items'].isNotEmpty)
                            generatePDF(data!, context)
                        },
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Enviar como PDF'),
                        style: _buttonStyle(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          openWhatsApp(contact);
                        },
                        icon: const Icon(FontAwesome.whatsapp,
                            color: Colors.green),
                        label: const Text('Contacto por Whastapp'),
                        style: _buttonStyle(Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration decoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(15),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ],
);
