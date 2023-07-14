import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart' as model;
import '../models/post.dart';
import '../models/comment.dart' as mode;

class FireMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Signup Method
  Future<String> signup(
      {required String username,
      required String email,
      required String password}) async {
    String result = 'An error occured';

    //Validating nulls for each TextField
    if (username.isNotEmpty || email.isNotEmpty || password.isNotEmpty) {
      //Try-Catch to prevent crashing
      try {
        //Create User with Auth method
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //creating user object from model
        model.User myUser = model.User(
            id: credential.user!.uid,
            email: email,
            username: username,
            password: password,
            dp: '',
            bio: '',
            posts: [],
            following: [],
            followers: []);
        //Store user data into Firestore
        _store
            .collection('User')
            .doc(credential.user!.uid)
            .set(myUser.toJson());
        result = 'success';
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  } //End Signup

  //lOGIN Method
  Future<String> login(
      {required String email, required String password}) async {
    String result = 'An error occured';

    //Validating each of the Login TextFields for Null values
    if (email.isNotEmpty || password.isNotEmpty) {
      //Try-Catch to prevent crashing due to errors
      try {
        //login user with Auth Method
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  } // End Login

  //Saving Bio and PFP url to Firestore
  Future<String> bioSignUp(
      {required String bio, required Uint8List file}) async {
    String result = 'An error occurred';
    try {
      String dp = await uploadImage(childName: 'dp', file: file, isPost: false);
      _store
          .collection('User')
          .doc(_auth.currentUser!.uid)
          .set({'bio': bio, 'dp': dp}, SetOptions(merge: true));
      result = 'success';
    } on Exception catch (e) {
      result = e.toString();
    }
    return result;
  }

  //Posting an image and Caption
  Future<String> postPic(
      {required String caption, required Uint8List file}) async {
    String result = 'An error occurred';
    try {
      String pic =
          await uploadImage(childName: 'post', file: file, isPost: true);
      _store.collection('User').doc(_auth.currentUser!.uid).update({
        'posts': [
          {'caption': caption, 'pic': pic}
        ]
      });
      result = 'success';
    } on Exception catch (e) {
      result = e.toString();
    }
    return result;
  }

  //Upload a Post
  Future<String> uploadPost({
    required Uint8List file,
    required String caption,
    required String username,
    required String dp,
  }) async {
    String result = 'An error occured';
    //Validating nulls for caption TextField
    if (caption.isNotEmpty || username.isEmpty) {
      //Try-Catch to prevent crashing
      try {
        //Get pic url
        String pic =
            await uploadImage(childName: 'post', file: file, isPost: true);

        //Generate Post ID (pid)
        String pid = const Uuid().v1();
        //creating user object from model
        Post myPost = Post(
          id: _auth.currentUser!.uid,
          pid: pid,
          caption: caption,
          username: username,
          pic: pic,
          dp: dp,
          likes: [],
          date: DateTime.now(),
        );

        //Store Post data into Firestore
        _store.collection('Post').doc(pid).set(myPost.toJson());
        result = 'success';
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  } //En

  //Upload Comments to fireStore
  Future<String> uploadComment({
    required String comment,
    required String username,
    required String dp,
    required String pid,
  }) async {
    String result = 'An error occured';
    //Validating nulls for caption TextField
    if (comment.isNotEmpty || username.isEmpty) {
      //Try-Catch to prevent crashing
      try {
        //Generate Comment ID (pid)
        String cid = const Uuid().v1();
        //creating user object from model
        mode.Comment myComment = mode.Comment(
          id: _auth.currentUser!.uid,
          cid: cid,
          username: username,
          dp: dp,
          likes: [],
          date: DateTime.now(),
          comment: comment,
        );

        //Store user data into Firestore
        _store
            .collection('Post')
            .doc(pid)
            .collection('Comment')
            .doc(cid)
            .set(myComment.toJson());
        result = 'success';
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  } //En

  //Upload Method to store image to Firebase_Storage
  Future<String> uploadImage(
      {required String childName,
      required Uint8List file,
      required bool isPost}) async {
    Reference reference =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String pid = const Uuid().v1();
      reference = reference.child(pid);
    }

    TaskSnapshot snap = await reference.putData(file);
    return await snap.ref.getDownloadURL();
  }

  //Get User info
  Future<model.User> getUserInfo() async {
    //Save Current user
    User currentUser = _auth.currentUser!;

    //Getting user info from FireStore as Snapshot
    DocumentSnapshot snap =
        await _store.collection('User').doc(currentUser.uid).get();
    return model.User.snapToUser(snap);
  }

  Future<void> addLike(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _store.collection('Post').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _store.collection('Post').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Comment like funtionality
  Future<void> commentLike(
      String pid, String cid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _store
            .collection('Post')
            .doc(pid)
            .collection('Comment')
            .doc(cid)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _store
            .collection('Post')
            .doc(pid)
            .collection('Comment')
            .doc(cid)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deletePost(String pid) async {
    try {
      _store.collection('Post').doc(pid).delete();
      // _storage.
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
