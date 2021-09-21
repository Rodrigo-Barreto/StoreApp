import 'package:app/provider/auth.dart';
import 'package:app/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  //--------------------------------------------------//

  final _passwordCOntroller = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

//--------------------------------------------------//

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

//--------------------------------------------------//

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller.reverse();
      }
    });
  }

  //----------------------Animation----------------------------//
  AnimationController _controller;
  Animation<Size> _heightAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //--------------------------------------------------//

  void _errorErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(error),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Report error"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Exit"),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    if (!formIsValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_isLogin()) {
        //Login
        await auth.signIn(
          email: _authData['email'],
          password: _authData['password'],
        );
      } else {
        await auth.signUp(
          email: _authData['email'],
          password: _authData['password'],
        );
      }
    } on AuthException catch (error) {
      _errorErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
      _authMode = AuthMode.Login;
    });
  }

  //--------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          height: _isLogin() ? 310 : 400,
          padding: EdgeInsets.all(8),
          width: deviceSize * 0.75,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _authData['email'] = value,
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
                  validator: _isLogin()
                      ? null
                      : (_value) {
                          final password = _value ?? '';
                          if (password.isEmpty || password.length < 5) {
                            return 'Insert one correct Password';
                          }
                          return null;
                        },
                ),
                if (_isSignup())
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                    constraints: BoxConstraints(
                      minHeight: _isLogin() ? 0 : 60,
                      maxHeight: _isLogin() ? 0 : 120,
                    ),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
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
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isLogin() ? "Sign In" : "Registred",
                        ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => _switchAuthMode(),
                  child: Text(_isLogin() ? "Sign up?" : "Sign in?"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
