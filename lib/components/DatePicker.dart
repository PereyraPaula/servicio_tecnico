import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({required this.onAdd});

  final void Function(String) onAdd;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;
  String _selectedDateFormatted = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        locale: const Locale("es", "ES"),
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
        _selectedDateFormatted = DateFormat('dd-MM-yyyy').format(selected);
        widget.onAdd(_selectedDateFormatted);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(LinearBorder.none),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent)),
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate == null
                  ? 'Seleccionar fecha'
                  : _selectedDateFormatted.toString(),
                  style: const TextStyle(fontSize: 16.0),
                )
              ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
