import 'package:flutter/material.dart';

class RegisterFromProvider extends ChangeNotifier {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set confirmPassword(String confirmPassword) {}
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidFrom() {
    print(fromKey.currentState?.validate());
    print('$email, $password');
    return fromKey.currentState?.validate() ?? false;
  }
}
