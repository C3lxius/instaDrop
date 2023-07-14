import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:instadrop/utilities/comment_card.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';

class CommentScreen extends StatefulWidget {
  String pid;
  CommentScreen({super.key, required this.pid});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController commentController;

  commentUpload(String username, String dp) async {
    await FireMethods().uploadComment(
        comment: commentController.text.trim(),
        username: username,
        dp: dp,
        pid: widget.pid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().myUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Comments'),
        backgroundColor: backgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(widget.pid)
            .collection('Comment')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: SizedBox());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommentCard(
                pid: widget.pid,
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(user.dp),
              radius: 20.0,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: commentController,
                autofocus: true,
                cursorColor: buttonColor,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: textColor)),
              ),
            )),
            IconButton(
                onPressed: () async {
                  await commentUpload(user.username, user.dp);
                  commentController.clear();
                },
                color: buttonColor,
                icon: const Icon(Icons.send_rounded))
          ],
        ),
      )),
    );
  }
}
