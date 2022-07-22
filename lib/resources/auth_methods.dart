import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intargram/resources/storage_methods.dart';
import 'package:intargram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<model.User> getUser() async {
    User currenUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currenUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signup user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        //register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // ignore: avoid_print
        print(credential.user!.uid);
        //download and upload image storage
        String urlImage = await StorageMethods()
            .uploadImageStorage('image_avatar', file, false);
        model.User user = model.User(
            username: username,
            uid: credential.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            imageAvatar: urlImage);
        //add user firestore
        await _fireStore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = 'success';
      } else {
        res = 'không được để trống';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'password should be at least 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //login user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'ô đăng nhập không được để trống';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
