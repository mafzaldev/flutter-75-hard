import 'package:flutter/foundation.dart';
import 'package:seventy_five_hard/models/user_model.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool? _defaultPenalty;

  User? get user => _user;
  bool? get defaultPenalty => _defaultPenalty;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setDefaultPenalty(bool? defaultPenalty) {
    _defaultPenalty = defaultPenalty;
    notifyListeners();
  }

  void logOut() async {
    SupabaseServices supabaseServices = SupabaseServices.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('75Hard-isLoggedIn', false);
    supabaseServices.logout();
    _user = null;
    _defaultPenalty = null;
    notifyListeners();
  }
}
