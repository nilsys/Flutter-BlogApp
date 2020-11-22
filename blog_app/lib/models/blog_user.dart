import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:blog_app/util/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';

class BlogUser {
  String uid;
  String email, picUrl, userName, name;
  String bio;
  BlogUser.fromMap(Map<String, dynamic> snap) {
    this.uid = snap[Constants.uid];
    this.email = snap[Constants.email];
    this.picUrl = snap[Constants.img];
    this.name = snap[Constants.name];
    this.userName = snap[Constants.userName];
    this.bio = snap[Constants.bio];
  }
  BlogUser({this.uid, this.email});

  BlogUser.user(User user) {
    BlogUser(email: user.email, uid: user.uid);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.email: email,
      Constants.img: picUrl,
      Constants.name: name,
      Constants.userName: userName,
      Constants.bio: bio
    };
  }
}
