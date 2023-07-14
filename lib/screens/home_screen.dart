import 'package:flutter/material.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  late PageController pageController;

  void onPageChange(int page) {
    setState(() {
      this.page = page;
    });
  }

  void onTap(int page) {
    setState(() {
      this.page = page;
      pageController.jumpToPage(page);
    });
  }

  call() async {
    await context.read<UserProvider>().refreshUser();
  }

  @override
  void initState() {
    call();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    // final user = context.watch<UserProvider>().myUser;
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChange,
          children: myScreens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        currentIndex: page,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: onTap,
      ),
    );
  }
}
