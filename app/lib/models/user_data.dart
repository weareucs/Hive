import 'package:demo_ucs/models/usermodel.dart';

class UserData {
  static final UserData _instance = UserData._internal();

  UserModel? currentUser;

  UserData._internal();

  factory UserData() {
    return _instance;
  }
}

final userData = UserData();
