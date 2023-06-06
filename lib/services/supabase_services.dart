// ignore_for_file: unused_field

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

  Future<String> signup(
      {required String email,
      required String password,
      required String username}) async {
    String response = '';
    try {
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      final Session? session = authResponse.session;
      final User? user = authResponse.user;

      if (session != null) {
        _session = session;
      }

      log('user: ${user!.email}');
      log('user: ${user.userMetadata}');
      await supabase.from('users').insert({
        'username': user.userMetadata!['username'],
        'email': user.email,
        'image_url':
            'https://api.dicebear.com/6.x/identicon/svg?seed=${user.userMetadata!['username']}'
      });

      response = "success";
    } on PostgrestException catch (e) {
      response = e.message.toString();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<Map<dynamic, dynamic>> login(
      {required String email, required String password}) async {
    final userData = {};
    try {
      AuthResponse authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _session = authResponse.session;
      User? user = authResponse.user;
      userData["username"] = user!.userMetadata!['username'];
      userData["email"] = user.email;

      final data = await supabase
          .from('users')
          .select('image_url')
          .eq('email', user.email);

      userData["imageUrl"] = data[0]["image_url"];
    } catch (e) {
      log('error: $e');
    }

    return userData;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
