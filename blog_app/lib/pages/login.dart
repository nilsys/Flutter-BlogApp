import 'package:blog_app/api/auth_api.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:blog_app/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  String _email, _password = "";
  final _formKey = GlobalKey<FormState>();

  AuthNotifier authNotifier;
  @override
  Widget build(BuildContext context) {
    authNotifier = Provider.of<AuthNotifier>(context); 
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 175.0, 0.0, 0.0),
                  child: Text(
                    'There',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(255.0, 175.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue))),
                  validator: (email) => EmailValidator.validate(email)
                      ? null
                      : "Invalid email address",
                  onSaved: (email) => _email = email,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue))),
                  obscureText: true,
                  validator: (pass) =>
                      pass.isEmpty ? "Password cannot be blank" : null,
                  onSaved: (pass) => _password = pass,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/forgotpassword");
                    },
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.lightBlueAccent,
                            color: Colors.lightBlue,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  bool result = await _logIn();
                                  if (result) {
                                    Navigator.pushReplacementNamed(
                                        context, "/navigationbar");
                                  } else {
                                    showSnackBar(context, "Login Failed");
                                  }
                                }
                              },
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.lightBlueAccent,
                            color: Colors.lightBlue,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                bool result = await _sigInGoogle();
                                if (result) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/navigationbar');
                                } else {
                                  showSnackBar(
                                      context, "Google Login Failed!!");
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Google Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New User ?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(
                width: 5.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _logIn() async {
    bool result = await signEmailPassword(_email, _password);

    if (result) {
      await initializeAuthNotifier(authNotifier);
      return true;
    } else {
      return false;
    }
  }
  /**
   * all the Function 
   */

  Future<bool> _sigInGoogle() async {
    var result = await signInWithGoogle();
    if (result) {
      await updatedLogedUserDetails();
      User user = FirebaseAuth.instance.currentUser;
      authNotifier.setUser(user);
      await initializeAuthNotifier(authNotifier);
      return true;
    } else {
      return false;
    }
  }

  void showSnackBar(BuildContext context, String snackBarText) {
    var snackBar = SnackBar(content: Text('Hi there'));

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        snackBarText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      backgroundColor: Colors.lightBlue,
    ));
  }
}
