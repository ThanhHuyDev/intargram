import 'package:flutter/cupertino.dart';
import 'package:intargram/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;
  Future<void> refreshUser()async{
    User user = await _authMethods.getUser();
    _user = user;
    notifyListeners();
  }
}