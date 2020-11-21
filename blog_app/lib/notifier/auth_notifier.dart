import 'package:blog_app/models/blog_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier with ChangeNotifier {
  User _user;
  BlogUser blogUser;

  User get user => _user;

  String get userId => _user.uid;

  void currentUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void blogUserDetails(BlogUser user) {
     blogUser = user;
  } 
}
