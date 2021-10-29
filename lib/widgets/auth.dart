import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth extends StatefulWidget {
  Auth(this.submitFn);
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFn;
  //const Auth({ Key? key }) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPwd = '';
  var _showSpinner = false;



  void _trySubmit() async {
    
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      //...
      _formKey.currentState!.save();
      setState(() {
        _showSpinner = true;
      });

      _formKey.currentState!.save();
      // print(_userName);
      // print(_userPwd);
      // print(_userEmail);
      //auth req to firebase

      widget.submitFn(_userEmail!.trim(), _userPwd!.trim(), _userName!.trim(),
          _isLogin, context);
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        height: _isLogin ? 350 : 450,
        child: Card(
          margin: const EdgeInsets.all(20),
          child: _showSpinner
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              key: const ValueKey('email'),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid Email';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              onSaved: (value) {
                                _userEmail = value;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                key: ValueKey('username'),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Enter a username with atleast 4 charectors';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'User Name',
                                ),
                                onSaved: (value) {
                                  _userName = value;
                                },
                              ),
                            TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Enter a password with atleast 7 charectors';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              onSaved: (value) {
                                _userPwd = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(
                                    _isLogin
                                        ? 'Create Account'
                                        : 'I have an account',
                                    //style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //shape: Rectangle(left, top, width, height),
                                    shadowColor: Colors.grey,
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: _trySubmit,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(_isLogin ? 'Login' : 'SignUp'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
