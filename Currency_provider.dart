// currency_provider.dart

import 'package:flutter/material.dart';

import 'currency_data.dart';

class CurrencyProvider extends ChangeNotifier {
  Temperatures? _temperatures;
  int _selectedItemIndex = 0;
  String _selectedCurrencyCode = '';
  String _selectedCurrencyRate = '';

  Temperatures? get temperatures => _temperatures;
  int get selectedItemIndex => _selectedItemIndex;
  String get selectedCurrencyCode => _selectedCurrencyCode;
  String get selectedCurrencyRate => _selectedCurrencyRate;

  void setTemperatures(Temperatures temperatures) {
    _temperatures = temperatures;
    _selectedCurrencyCode = temperatures.bpi.currencies[_selectedItemIndex].code;
    _selectedCurrencyRate = temperatures.bpi.currencies[_selectedItemIndex].rate;
    notifyListeners();
  }

  void setSelectedItemIndex(int index) {
    _selectedItemIndex = index;
    _selectedCurrencyCode = _temperatures!.bpi.currencies[index].code;
    _selectedCurrencyRate = _temperatures!.bpi.currencies[index].rate;
    notifyListeners();
  }
}
