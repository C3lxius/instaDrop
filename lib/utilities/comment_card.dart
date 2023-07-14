import 'package:flutter/material.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/utilities/likeanimation.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'constants.dart';

class CommentCard extends StatefulWidget {
  final String pid;
  final Map<String, dynamic> snap;
  const CommentCard({super.key, required this.pid, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().myUser;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(widget.snap['dp']),
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '   ${widget.snap['date'].toDate().toString()}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: textColor),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(widget.snap['comment']),
                  )
                ],
              )),
        ),
        Column(
          children: [
            LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.id),
                child: IconButton(
                    onPressed: () async {
                      await FireMethods().commentLike(widget.pid,
                          widget.snap['cid'], user.id, widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.id)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border))),
            Text('${widget.snap['likes'].length}'),
          ],
        ),
      ],
    );
  }
}
