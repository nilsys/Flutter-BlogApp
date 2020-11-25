import 'dart:io';

import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/models/postdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/util/constants.dart' as constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> likePost(String postId, String uid) async {
  try {
    var doc = FirebaseFirestore.instance
        .collection(constants.posts)
        .doc(postId); //document reference to the post

    DocumentSnapshot snap = await doc.get();

    if (!snap.exists) return;

    DocumentReference likeDoc = doc.collection(constants.likes).doc(uid);
    DocumentSnapshot likeSnap = await likeDoc.get();
    print("likesnap exits ; ${likeSnap.exists}");
    if (likeSnap.exists)
      return; // the User has already likes the image so return

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
          likeDoc,
          {
            constants.uid: uid,
            constants.timestamp: FieldValue.serverTimestamp()
          },
          SetOptions(merge: true));

      transaction.set(doc, {constants.likes: FieldValue.increment(1)},
          SetOptions(merge: true));
    });
  } catch (err) {
    print("Like Post Error : $err");
    return;
  }
}

Future<void> unLikePost(String postId, String uid) async {
  var doc = FirebaseFirestore.instance.collection(constants.posts).doc(postId);

  DocumentSnapshot snap = await doc.get();

  if (!snap.exists) return;

  DocumentReference likeDoc = doc.collection(constants.likes).doc(uid);
  DocumentSnapshot likeSnap = await doc.get();
  if (!likeSnap.exists) return; // return if no record for the user like

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.delete(likeDoc);
    transaction.update(doc, {constants.likes: FieldValue.increment(-1)});
  });
}

Future<bool> uploadPost(
    String _title, String _content, File imageFile, BlogUser user) async {
  CollectionReference ref =
      FirebaseFirestore.instance.collection(constants.posts);

  DocumentReference doc = ref.doc();

  String url = await uploadImage(imageFile, doc.id);
  if (url == null) return false;
  Post post = Post(
      content: _content,
      id: doc.id,
      liked: false,
      image: url,
      title: _title,
      date: null,
      name: user.name,
      username: user.userName,
      userId: user.uid,
      likes: 0);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(doc, post.toMap());
  });
  return true;
}

Future<String> uploadImage(File imageFile, String id) async {
  try {
    var task = await firebase_storage.FirebaseStorage.instance
        .ref("posts/$id")
        .putFile(imageFile);
    return await task.ref.getDownloadURL();
  } catch (e) {
    print("Image Upload Error : $e");
    return null;
  }
}

Future<bool> uploadProfile(BlogUser user) async {
  try {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    var doc = firebase.collection(constants.users).doc(user.uid);
    await firebase.runTransaction((transaction) async {
      transaction.update(doc, user.toMap());
    });
    return true;
  } catch (err) {
    print("Upload Profile Error : $err");
    return false;
  }
}

Future<bool> uploadProfileWithImage(BlogUser user, String imagePath) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String url = await uploadProfileImage(imagePath);
    user.picUrl = url;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    var doc = firebase.collection(constants.users).doc(user.uid);
    await firebase.runTransaction((transaction) async {
      transaction.update(doc, user.toMap());
    });
    return true;
  } catch (err) {
    print("Upload Profile Image Error : $err");
    return false;
  }
}

Future<String> uploadProfileImage(String path) async {
  File img = File(path);
  var task = await firebase_storage.FirebaseStorage.instance
      .ref(constants.users)
      .putFile(img);
  return task.ref.getDownloadURL();
}

//Function to get the whether the use has liked the post

Future<bool> get_like(String uid) async {
  String userId = FirebaseAuth.instance.currentUser.uid;
  var doc = FirebaseFirestore.instance
      .collection(constants.posts)
      .doc(uid)
      .collection(constants.likes)
      .doc(userId);

  var snap = await doc.get();

  if (!snap.exists)
    return false; // no like under this user present
  else
    return true;
}

Future<void> deletePostById(String id) async {
  DocumentReference doc =
      FirebaseFirestore.instance.collection(constants.posts).doc(id);

  try {
    await FirebaseFirestore.instance
        .runTransaction((transaction) async => transaction.delete(doc));
  } catch (err) {
    print("Delte post Erro : $err");
  }
}
