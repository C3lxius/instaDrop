import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instadrop/screens/home_screen.dart';
import 'package:instadrop/screens/login_screen.dart';
import 'package:instadrop/utilities/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else if (snapshot.hasError) {
                return SafeArea(
                    child: Center(
                  child: Text('${snapshot.error}'),
                ));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SafeArea(
                  child: Center(
                      child: CircularProgressIndicator(color: Colors.white)));
            }
            return const LoginScreen();
          }),
    );
  }
}
