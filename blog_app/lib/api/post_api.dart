import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/util/constants.dart' as constants;

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
    transaction.set(likeDoc, {
      constants.uid: uid,
      constants.timestamp: FieldValue.serverTimestamp()
    } , SetOptions(merge: true));

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
