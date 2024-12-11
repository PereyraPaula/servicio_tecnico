import 'package:flutter/widgets.dart';

class PdfDataWidget {
  final List<Map<String, dynamic>> data;
  final String date;
  final double? total;

  PdfDataWidget({
    required this.data,
    required this.date,
    this.total,
  });
}

class ControllersInputs {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  ControllersInputs(
      {required this.nameController, required this.phoneController});
}
