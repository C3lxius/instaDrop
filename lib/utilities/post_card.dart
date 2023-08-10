import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/pageview/profile_page.dart';
import 'package:instadrop/screens/comment_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'constants.dart';
import 'likeanimation.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool likeAnimation = false;

  showDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.watch<UserProvider>().myUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () async {
            await FireMethods()
                .addLike(widget.snap?['pid'], 'user.id', widget.snap?['likes']);
            setState(() {
              likeAnimation = true;
            });
          },
          child: Stack(children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.network(
                widget.snap?['pic'],
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfilePage(uid: widget.snap?['id'])));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(widget.snap?['dp']),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.snap?['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDelete(context);
                      },
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width / 2) - 60,
              top: 110,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: likeAnimation ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: likeAnimation,
                  onEnd: () {
                    setState(() {
                      likeAnimation = false;
                    });
                  },
                  child: const Icon(Icons.favorite,
                      size: 120, color: Colors.white),
                ),
              ),
            )
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap?['likes'].contains('user.id'),
                isLike: true,
                child: IconButton(
                    iconSize: 35,
                    onPressed: () async {
                      setState(() {
                        likeAnimation = true;
                      });
                      await FireMethods().addLike(widget.snap?['pid'],
                          'user.id', widget.snap?['likes']);
                    },
                    icon: widget.snap?['likes'].contains('user.id')
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(pid: widget.snap?['pid'])));
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.send_outlined)),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_outline))),
              ),
            ],
          ),
        ),

        //Decsription and Comment section
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text('${widget.snap?['likes'].length} likes',
              style: Theme.of(context).textTheme.bodyMedium),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
          child: RichText(
              text: TextSpan(
            children: [
              TextSpan(
                  text: widget.snap?['username'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: '  ${widget.snap?['caption']}.',
              ),
            ],
          )),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Post')
                  .doc(widget.snap?['pid'])
                  .collection('Comment')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("View all comments",
                      style: TextStyle(color: textColor));
                }
                return Text("View all ${snapshot.data?.docs.length} comments",
                    style: const TextStyle(color: textColor));
              }),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
          child: Text('${widget.snap?['date'].toDate().toString()}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: textColor)),
        ),
      ],
    );
  }
}
