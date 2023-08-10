import 'package:flutter/material.dart';
import '../models/user.dart' as model;
import '../methods/fire_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _myUser;

  model.User get myUser => _myUser!;

  refreshUser() async {
    _myUser = await FireMethods().getUserInfo();
    notifyListeners();
  }
}
