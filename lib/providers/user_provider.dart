import 'package:flutter/foundation.dart';
import 'package:seventy_five_hard/models/user_model.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void logOut() async {
    SupabaseServices supabaseServices = SupabaseServices.instance;
    supabaseServices.logout();
    _user = null;
    notifyListeners();
  }
}
