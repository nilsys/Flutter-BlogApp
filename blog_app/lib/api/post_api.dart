import 'dart:io';

import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/models/postdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/util/constants.dart' as constants;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> likePost(String postId, String uid) async {
  await Future.delayed(const Duration(seconds: 3));
  print("like post done");
  return;

  var doc = FirebaseFirestore.instance.collection(constants.posts).doc(postId);

  DocumentSnapshot snap = await doc.get();

  if (!snap.exists) return;

  /// return if the post doesn't exits

  DocumentReference likeDoc = doc.collection(constants.likes).doc(uid);
  DocumentSnapshot likeSnap = await doc.get();
  if (likeSnap.exists) return; // the User has already likes the image so return

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
        likeDoc,
        {constants.uid: uid, constants.timestamp: FieldValue.serverTimestamp()},
        SetOptions(merge: true));

    transaction.set(doc, {constants.likes: FieldValue.increment(1)});
  });
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

Future<bool> uploadPost(String _title, String _content, File imageFile) async {
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
      name: "name",
      username: "user",
      likes: 0);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(doc, post.toMap());
  });
  return true;
}

Future<String> uploadImage(File imageFile, String id) async {
  try {
    var t = await firebase_storage.FirebaseStorage.instance
        .ref("posts/$id")
        .putFile(imageFile);
    return "hello";
    // return await t.ref.getDownloadURL();
  } catch (e) {
    print("Image Upload Error : $e");
    return null;
  }
}

// Future<void> uploadProfile(BlogUser user) {
//   FirebaseFirestore.instance.collection(constants.users).doc(userId); 
// }
