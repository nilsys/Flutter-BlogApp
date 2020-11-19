
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/signup.dart';
import 'package:blog_app/pages/login.dart';
import 'package:blog_app/pages/firstpage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/firstpage',
    routes: {
      '/login': (context) => Login(),
      '/signup': (context) => SignUp(),
      '/firstpage': (context) => FirstPage(),
    },
  ));
}



