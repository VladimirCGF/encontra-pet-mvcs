import 'package:flutter/material.dart';
import '../model/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser = UserModel(
    id: '1',
    name: 'Vladimir Silva',
    email: 'vladimir@email.com',
    phone: '(11) 99999-9999',
  );

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void login(String email, String password) {
    // Mock login
    _currentUser = UserModel(
      id: '1',
      name: 'Vladimir Silva',
      email: email,
      phone: '(11) 99999-9999',
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
