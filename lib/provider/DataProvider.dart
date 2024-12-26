import 'package:flutter/material.dart';
import 'package:servicio_tecnico/utils/exports.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data => _data;

  String get total {
    double total = _data.fold(0, (sum, item) {
      String sumString = sum.toString().replaceAll(",", "");
      String itemTotalString = item['total'].replaceAll(",", "");
      double sumValue = double.parse(sumString);
      double itemValue = double.parse(itemTotalString);
      return sumValue + itemValue;
    });

    return formattedResultMoney(total);
  }

  int get quantity {
    return _data.length;
  }

  void addItem(Map<String, dynamic> item) {
    _data.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _data.length) {
      _data.removeAt(index);
      notifyListeners();
    }
  }

  void clearData() {
    _data.clear();
    notifyListeners();
  }
}
