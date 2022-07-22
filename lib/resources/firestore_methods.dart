import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intargram/models/post.dart';
import 'package:intargram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //uploadPost
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageStorage('post', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: caption,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }

      // ignore: empty_catches
    } catch (e) {}
  }
  Future<void> postComment(String postId,String text,String uid,String name,String profImage)async{
      try{
        if(text.isNotEmpty){
          String commentId= const Uuid().v1();
          await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
            'profImage': profImage,
            'name': name,
            'uid' : uid,
            'text': text,
            'commentId': commentId,
            'dataPublished' : DateTime.now()
          });
        }else{  
          // ignore: avoid_print
          print('text is empty');
        }
      }catch(e){
        // ignore: avoid_print
        print(e.toString());
      }
  }
  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
