import 'dart:io';

import 'package:chatesh/widgets/user_image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth extends StatefulWidget {
  Auth(this.submitFn, this.isLoadingAuth);
  final bool isLoadingAuth;
  final void Function(
    String email, 
    String password, 
    String username,
    File image,
    bool isLogin, 
    BuildContext ctx
    ) submitFn;
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
  // ignore: prefer_typing_uninitialized_variables
  var _userImageFile;

  void _pickedImage(File image)
  {
    _userImageFile = image;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(_userImageFile == null && !_isLogin)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please click a pic!'), backgroundColor: Colors.red,));

      return;
    }
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

      widget.submitFn(
        _userEmail!.trim(), 
        _userPwd!.trim(), 
        _userName!.trim(),
        _userImageFile,
        _isLogin, 
        context,
        );
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
      height: _isLogin ? 320 : 500,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: _showSpinner
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(!_isLogin) UserImagePicker(_pickedImage),
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
                            key: const ValueKey('username'),
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
                          key: const ValueKey('password'),
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
                        if (widget.isLoadingAuth)
                          const Center(child: CircularProgressIndicator()),
                        if (!widget.isLoadingAuth)
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
    ));
  }
}

//UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile: {}, providerId: null, username: null), credential: null, user: User(displayName: null, email: tester4@test.com, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2021-10-31 20:08:41.518, lastSignInTime: 2021-10-31 20:08:41.518), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: tester4@test.com, phoneNumber: null, photoURL: null, providerId: password, uid: tester4@test.com)], refreshToken: , tenantId: null, uid: xfPeKHiNLXQVD8rLhjQvg0u88ns1)) 