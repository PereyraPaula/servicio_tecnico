import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:servicio_tecnico/classes/Exports.dart';
import 'package:servicio_tecnico/components/AddRowDialog.dart';
import 'package:servicio_tecnico/components/DatePicker.dart';
import 'package:servicio_tecnico/provider/ThemeProvider.dart';
import 'package:servicio_tecnico/screens/TableViewScreen.dart';
import 'package:servicio_tecnico/utils/exports.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile(
      {super.key,
      required this.data,
      this.quantity = 0,
      this.total = "0.00",
      required this.addItem});

  final List<Map<String, dynamic>> data;
  final String? total;
  final int? quantity;
  final void Function(Map<String, dynamic>) addItem;

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String total = "0.00";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctxTheme = context.watch<ThemeProvider>();

    return SafeArea(
      child: Column(
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
          const SizedBox(
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "",
                    isDense: true,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "",
                      isDense: true,
                    ),
                    keyboardType: TextInputType.phone),
              )
            ],
          ),
          const SizedBox(
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
                          widget.addItem(data);
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
                          builder: (context) => const TableViewScreen()));
                },
                label: const Text('Ver tabla'),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Text(
                'Total: \$${widget.total}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text('Cantidad de registros: ${widget.quantity}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: ctxTheme.isDarkTheme
                          ? Colors.grey[400]
                          : Colors.grey[700])),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Row(
            children: [
              Text(
                'Compartir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: (date.isNotEmpty && widget.data.isNotEmpty)
                    ? () {
                        createPdf(
                            context,
                            StructureData(
                                data: widget.data,
                                date: date,
                                total: widget.total),
                            ControllersInputs(
                                nameController: _nameController,
                                phoneController: _phoneController));
                      }
                    : null,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Como PDF'),
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        (date.isNotEmpty && widget.data.isNotEmpty)
                            ? Colors.red
                            : Colors.grey),
                    foregroundColor: WidgetStateProperty.all(Colors.white)),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: (date.isNotEmpty && widget.data.isNotEmpty)
                    ? () {
                    createImage(
                      context,
                      ControllersInputs(
                        nameController: _nameController,
                        phoneController: _phoneController),
                      screenshotController,
                      StructureData(data: widget.data, date: date, total: widget.total)
                    );
                    }
                    : null,
                icon: const Icon(Icons.image),
                label: const Text('Como Imagen'),
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        (date.isNotEmpty && widget.data.isNotEmpty)
                            ? Colors.blueAccent
                            : Colors.grey),
                    foregroundColor: WidgetStateProperty.all(Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
