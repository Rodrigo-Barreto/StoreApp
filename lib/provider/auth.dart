import 'dart:async';
import 'dart:convert';

import 'package:app/utils/app_routes.dart';
import 'package:app/utils/exceptions.dart';
import 'package:app/utils/local_store.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/urls.dart';

enum isAuthDe {
  Exit,
  login,
  Product,
}

class Auth with ChangeNotifier {
  String _email;
  String _token;
  String _userId;
  DateTime _expiresIn;
  Timer _logoutTimer;
  bool exit = true;

  bool get isAuth {
    final isValid = _expiresIn?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String get token {
    return isAuth ? _token : null;
  }

  String get email {
    return isAuth ? _email : null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      {String email, String password, String url}) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiresIn = DateTime.now().add(
        Duration(
          seconds: int.parse(
            body['expiresIn'],
          ),
        ),
      );
      LocalStore.saveMAp(
        'userData',
        {
          'token': _token,
          'email': _email,
          'localId': _userId,
          'expiresIn': _expiresIn.toIso8601String()
        },
      );
      _autoLogautTimer();
      notifyListeners();
    }
  }

  Future<void> tryLoginaAutoLogin() async {
    if (isAuth) return;
    final userData = await LocalStore.getMap('userData');
    if (userData.isEmpty) return;
    final expireIn = DateTime.parse(userData['expiresIn']);
    if (expireIn.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['localId'];
    _expiresIn = expireIn;
    _autoLogautTimer;
    notifyListeners();
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      url: baseUrl.urlSingUp,
    );
  }

  Future<void> signIn({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      url: baseUrl.urlSingIn,
    );
  }

  void logout() {
    _email = null;
    _token = null;
    _userId = null;
    _expiresIn = null;
    clearAutoLogautTimer();
    LocalStore.remove('userData');
    notifyListeners();
  }

  void clearAutoLogautTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogautTimer() {
    clearAutoLogautTimer();
    final timeLogout = _expiresIn?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeLogout ?? 0),
      logout,
    );
    print(timeLogout);
  }
}
