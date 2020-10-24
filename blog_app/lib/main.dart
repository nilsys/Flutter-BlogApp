import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/signup.dart';
import 'package:blog_app/pages/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/signup',
    routes: {
      '/login': (context) => Login(),
      '/signup': (context) => SignUp(),
    },
  ));
}



