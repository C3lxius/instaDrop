import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instadrop/utilities/constants.dart';

import '../utilities/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/ic.svg',
            color: primaryColor,
            height: 30.0,
          ),
          centerTitle: false,
          backgroundColor: backgroundColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.messenger_outline_sharp))
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Post').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PageCard(
                    snap: snapshot.data?.docs[index].data(),
                  ),
                ),
              );
            }));
  }
}
