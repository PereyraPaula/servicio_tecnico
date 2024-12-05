import 'package:flutter/material.dart';

class AddRowDialog extends StatefulWidget {
  final void Function(Map<String, String>) onAdd;

  AddRowDialog({required this.onAdd});

  @override
  _AddRowDialogState createState() => _AddRowDialogState();
}

class _AddRowDialogState extends State<AddRowDialog> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController puController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  bool isCantidadValid = true;
  bool isDescripcionValid = true;
  bool isTotalValid = true;
  String errorMessage = '';

  void validateAndSubmit() {
    setState(() {
      isCantidadValid = cantidadController.text.isNotEmpty;
      isDescripcionValid = descripcionController.text.isNotEmpty;
      isTotalValid = totalController.text.isNotEmpty;

      if (isCantidadValid && isDescripcionValid && isTotalValid) {
        final data = {
          "cantidad": cantidadController.text,
          "descripcion": descripcionController.text,
          "pu": puController.text,
          "total": totalController.text,
        };
        widget.onAdd(data);
        Navigator.of(context).pop();
      } else {
        errorMessage = 'Todos los campos son requeridos.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agregar nuevo registro', style: TextStyle(fontSize: 20),),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red[900], fontSize: 14),
                ),
              ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    errorText: isCantidadValid ? null : 'Este campo es obligatorio',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isCantidadValid ? Colors.grey : Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isCantidadValid ? Colors.blue : Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descripcionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    errorText: isDescripcionValid ? null : 'Este campo es obligatorio',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDescripcionValid ? Colors.grey : Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDescripcionValid ? Colors.blue : Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: puController,
                  keyboardType: TextInputType.number,
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: const InputDecoration(
                    labelText: 'P.U',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: totalController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: InputDecoration(
                    labelText: 'Total',
                    errorText: isTotalValid ? null : 'Este campo es obligatorio',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isTotalValid ? Colors.grey : Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isTotalValid ? Colors.blue : Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: validateAndSubmit,
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}