import 'package:flutter/material.dart';
import 'package:instadrop/utilities/constants.dart';

class SearchCard extends StatelessWidget {
  final Map snap;
  const SearchCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(snap['dp']),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  '${snap['username']}',
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    //TODO: fix followers
                    '22k followers',
                    style: TextStyle(color: textColor),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
