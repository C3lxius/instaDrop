import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instadrop/screens/explore_screen.dart';
import 'package:instadrop/utilities/post_card.dart';

class SearchStaggered extends StatelessWidget {
  const SearchStaggered({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('Post').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ExploreScreen(
                                      startIndex: index,
                                      snap: snapshot.data!.docs,
                                    )));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: NetworkImage(
                                    snapshot.data!.docs[index].data()['pic'])),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
          return const SizedBox();
        });
  }
}
