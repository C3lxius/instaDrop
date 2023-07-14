import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String username;
  final String password;
  final String dp;
  final String bio;
  final List<dynamic> posts;
  final List<dynamic> following;
  final List<dynamic> followers;

  const User(
      {required this.id,
      required this.email,
      required this.username,
      required this.password,
      required this.dp,
      required this.bio,
      required this.posts,
      required this.following,
      required this.followers});

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "dp": dp,
        "bio": bio,
        "posts": posts,
        "following": following,
        "followers": followers
      };

  static User snapToUser(DocumentSnapshot snap) {
    final info = snap.data() as Map<String, dynamic>;
    return User(
        id: info['id'],
        email: info['email'],
        username: info['username'],
        password: info['password'],
        dp: info['dp'],
        bio: info['bio'],
        posts: info['posts'],
        following: info['following'],
        followers: info['followers']);
  }
}
