import 'package:flutter/material.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:instadrop/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  bool isUser;
  String? userInfo;
  ProfilePage({super.key, this.isUser = true, this.userInfo});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().myUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(userInfo ?? user.username),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 24.0, bottom: 8.0),
        child: Column(children: [
          //Row for dp, post and followers/following
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage: isUser ? NetworkImage(user.dp) : null,
              ),
              const Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text('posts', style: TextStyle(fontSize: 16.0))
                ],
              ),
              const Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text('followers', style: TextStyle(fontSize: 16.0))
                ],
              ),
              const Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text('following', style: TextStyle(fontSize: 16.0))
                ],
              ),
              const SizedBox(),
            ],
          ),

          //Row for Full Name and BIO
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isUser ? user.username : 'username',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text(isUser ? user.bio : 'some random biodata'),
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
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                buttonColor.withOpacity(0.8))),
                        child: Text(isUser ? 'Edit Profile' : 'Follow'))),
                const SizedBox(width: 10.0),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
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

          //Gridview of Posts
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0),
                itemCount: 20,
                itemBuilder: ((context, index) {
                  return const Placeholder();
                })),
          ),
        ]),
      ),
    );
  }
}
