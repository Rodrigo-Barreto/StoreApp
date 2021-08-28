import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthCard extends StatelessWidget {
  final _passwordCOntroller = TextEditingController();
  Map<String, String> _authData = {'email': '', 'password': ''};
  void _submit() {}

  @override
  Widget build(BuildContext context) {
    AuthMode _authMode = AuthMode.Login;
    final deviceSize = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8.0,
        child: Container(
          height: 320,
          padding: EdgeInsets.all(8),
          width: deviceSize * 0.75,
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (_value) {
                    final email = _value ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Insert one correct Email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  keyboardType: TextInputType.text,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  obscureText: true,
                  controller: _passwordCOntroller,
                  validator: _authMode == AuthMode.Login
                      ? null
                      : (_value) {
                          final password = _value ?? '';
                          if (password.isEmpty || password.length < 5) {
                            return 'Insert one correct PassWord';
                          }
                          return null;
                        },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (_value) {
                      final password = _value ?? '';
                      if (password != _passwordCOntroller.text) {
                        return 'Password differents';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.Login ? "Sign In" : "Registred",
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
