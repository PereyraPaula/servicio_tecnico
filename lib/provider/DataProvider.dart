import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data => _data;

  double get total {
    return _data.fold(0, (sum, item) => sum + int.parse(item['total']));
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
