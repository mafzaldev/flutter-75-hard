import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:seventy_five_hard/models/user_model.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool? _defaultPenalty;

  User? get user => _user;
  bool? get defaultPenalty => _defaultPenalty;

  void setUser(User? user) {
    _user = user;
    log("_user: $_user.username");
    notifyListeners();
  }

  void setDefaultPenalty(bool? defaultPenalty) {
    _defaultPenalty = defaultPenalty;
    notifyListeners();
  }

  void logOut() async {
    SupabaseServices supabaseServices = SupabaseServices.instance;
    supabaseServices.logout();
    _user = null;
    _defaultPenalty = null;
    notifyListeners();
  }
}
