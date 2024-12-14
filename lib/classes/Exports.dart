import 'package:flutter/widgets.dart';

class StructureData {
  final List<Map<String, dynamic>> data;
  final String date;
  final double? total;

  StructureData({
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
