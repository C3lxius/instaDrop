import 'package:flutter/material.dart';
import '../pageview/home_page.dart';
import '../pageview/notif_page.dart';
import '../pageview/post_page.dart';
import '../pageview/profile_page.dart';
import '../pageview/search_page.dart';

// const backgroundColor = Color.fromARGB(0, 0, 0, 1);
const backgroundColor = Color(0xff111111);
const primaryColor = Colors.white;
const cardColor = Color(0xff1f1f1f);
const buttonColor = Color(0xFF64feda);
const textColor = Colors.grey;
List<Widget> myScreens = [
  HomePage(),
  SearchPage(),
  PostPage(),
  NotifPage(),
  ProfilePage(),
];
