import 'package:blog_app/api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tuple/tuple.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  String _name, _email, _password = "";

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                      child: Text(
                        'Enter your details',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(295.0, 50.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
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
                          labelText: 'FULL NAME',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                      validator: (name) {
                        Pattern pattern =
                            r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)";
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(name))
                          return 'Invalid name';
                        else
                          return null;
                      },
                      onSaved: (name) => _name = name,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _pass,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                      validator: (password) {
                        // Pattern pattern =
                        //     r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                        // RegExp regex = new RegExp(pattern);
                        // if (!regex.hasMatch(password))
                        //   return 'Invalid password';
                        // else
                        //   return null;
                        return null; 
                      },
                      onSaved: (password) => _password = password,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _confirmPass,
                      decoration: InputDecoration(
                          labelText: 'CONFIRM PASSWORD',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                      validator: (confirmpassword) {
                        if (confirmpassword != _pass.text) {
                          return 'not match';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.lightBlue,
                        elevation: 7.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              var result = await registerUser();
                              if(result)
                                Navigator.pushNamed(context, '/login');
                              
                            }
                          },
                          child: Center(
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
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
                    'Already a User ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Login',
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
        ),
      ),
    );
  }

  Future<bool> registerUser() async {
    Tuple2<bool , String> authResult = await regsiterWithEmailandPassword(_email, _password, _name);
    if(authResult.item1){
      return true  ; 
    }
    else{
      showSnackBar(authResult.item2) ; 
      return false ; 
    }
  }

  void showSnackBar(String snackBarText) {
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
