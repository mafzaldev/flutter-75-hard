import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  Session? _session;
  static SupabaseServices? _instance;

  SupabaseServices._();

  static SupabaseServices get instance {
    _instance ??= SupabaseServices._();
    return _instance!;
  }

  final supabase = Supabase.instance.client;

  void signup(
      {required String email,
      required String password,
      required String username}) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    final Session? session = res.session;
    final User? user = res.user;
    log('session: $session');
    log('user: $user');
  }

  Future<User> login({required String email, required String password}) async {
    AuthResponse? res;
    try {
      res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _session = res.session;
    } catch (e) {
      log('error: $e');
    }

    final User? user = res!.user;
    log('user: ${user!.email}');
    return user;
  }
}
