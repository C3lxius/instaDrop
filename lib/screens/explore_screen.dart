import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utilities/constants.dart';
import '../utilities/post_card.dart';

class ExploreScreen extends StatelessWidget {
  String title;
  final List snap;
  final int startIndex;
  ExploreScreen(
      {super.key,
      this.title = 'Explore',
      required this.snap,
      this.startIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: false,
          backgroundColor: backgroundColor,
        ),
        body: ScrollablePositionedList.builder(
          itemCount: snap.length,
          initialScrollIndex: startIndex,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostCard(
                snap: snap[index].data(),
              ),
            );
          },
        ));
  }
}
