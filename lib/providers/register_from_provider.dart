import 'package:flutter/material.dart';

class RegisterFromProvider extends ChangeNotifier {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String email = '';
  String contrasena = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set confirmcontrasena(String confirmcontrasena) {}
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidFrom() {
    return fromKey.currentState?.validate() ?? false;
  }
}
