import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      style: TextButton.styleFrom(minimumSize: const Size(60, 40)),
      child: const Text('Sign Out'),
    );
  }
}
