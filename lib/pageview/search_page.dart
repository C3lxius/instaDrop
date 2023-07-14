import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instadrop/pageview/profile_page.dart';
import 'package:instadrop/utilities/constants.dart';
import 'package:instadrop/utilities/myTextField.dart';
import 'package:instadrop/utilities/search_card.dart';
import 'package:instadrop/utilities/search_stackered.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;
  bool show = true;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: backgroundColor, actions: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              cursorColor: textColor,
              decoration: const InputDecoration(
                  hintText: 'search...',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  fillColor: textColor,
                  suffixIconColor: textColor),
              onFieldSubmitted: (_) {
                setState(() {
                  show = false;
                });
              },
            ),
          ),
        )
      ]),
      body: Column(
        children: [
          show
              ? const SearchStackered()
              : FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('User')
                      .where('username',
                          isGreaterThanOrEqualTo: searchController.text)
                      .get(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: buttonColor));
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snap.data!.docs.length,
                          itemBuilder: ((context, index) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(isUser: false)));
                                  },
                                  child: SearchCard(
                                    snap: snap.data!.docs[index].data(),
                                  ),
                                ),
                              ))),
                    );
                  }),
        ],
      ),
    );
  }
}
