import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/methods/other_methods.dart';
import 'package:instadrop/pageview/search_page.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:instadrop/screens/explore_screen.dart';
import 'package:instadrop/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  String uid;
  ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  late bool isUser;
  bool isFollowing = false;
  bool isLoading = false;

  setBool() {
    FirebaseAuth.instance.currentUser!.uid == widget.uid
        ? isUser = true
        : isUser = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBool();
    getData();
    // isLoading = true;
  }

  checkFollow() {
    if (userData['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      isFollowing = true;
    }
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('Post')
          .where('id', isEqualTo: widget.uid)
          .get();

      userData = userSnap.data()!;
      postLength = postSnap.docs.length;
      followers = userData['followers'].length;
      following = userData['following'].length;
      checkFollow();
      setState(() {
        isLoading = true;
      });
    } on Exception catch (e) {
      showSnack(content: e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(userData['username']),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SearchPage()));
                    },
                    icon: const Icon(Icons.notifications_outlined)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 24.0, bottom: 8.0),
              child: Column(children: [
                //Row for dp, post and followers/following
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['dp']),
                      ),
                      buildStats(postLength, 'posts'),
                      buildStats(followers, 'followers'),
                      buildStats(following, 'following'),
                      const SizedBox(),
                    ],
                  ),
                ),

                //Row for Full Name and BIO
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['username'],
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3.0),
                          Text(userData['bio']),
                        ],
                      ),
                    ),
                  ],
                ),

                //Row for follow button and message button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (isUser) {
                                  print('edit');
                                } else {
                                  FireMethods().follow(widget.uid, isFollowing);
                                  setState(() {
                                    if (isFollowing) {
                                      isFollowing = false;
                                      followers--;
                                    } else {
                                      isFollowing = true;
                                      followers++;
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      buttonColor.withOpacity(0.8))),
                              child: Text(isUser
                                  ? 'Edit Profile'
                                  : (isFollowing ? 'Unfollow' : 'Follow')))),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                isUser
                                    ? FireMethods().signOut()
                                    : print('message');
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      buttonColor.withOpacity(0.8))),
                              child: Text(isUser ? 'Sign Out' : 'Message')))
                    ],
                  ),
                ),

                const Divider(
                  thickness: 0.5,
                  color: Colors.white54,
                ),

                // Gridview of Posts
                Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Post')
                          .where('id', isEqualTo: userData['id'])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 3.0,
                                    crossAxisSpacing: 3.0),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ExploreScreen(
                                          title: userData['username'],
                                          startIndex: index,
                                          snap: snapshot.data!.docs)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Image(
                                      image: NetworkImage(snapshot
                                          .data!.docs[index]
                                          .data()['pic'])),
                                ),
                              );
                            }));
                      }),
                ),
              ]),
            ),
          )
        : const SafeArea(child: SizedBox());
  }

  Column buildStats(int num, String label) => Column(
        children: [
          Text(
            num.toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text(label, style: const TextStyle(fontSize: 16.0))
        ],
      );
}
