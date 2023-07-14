// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instadrop/methods/other_methods.dart';
import 'package:instadrop/screens/biosignup_screen.dart';
import 'package:instadrop/screens/login_screen.dart';
import 'package:instadrop/utilities/constants.dart';
import '../utilities/myTextField.dart';
import '../methods/fire_methods.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isLoading = false;

  void toBioSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BioSignup()));
  }

  void toLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void signup() async {
    setState(() {
      isLoading = true;
    });

    String res = await FireMethods().signup(
        username: userController.text.trim().toLowerCase(),
        email: emailController.text.trim().toLowerCase(),
        password: passController.text.trim().toLowerCase());
    if (res == 'success') {
      toBioSignup();
    } else {
      showSnack(content: res, context: context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Flexible(flex: 1, child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/ic.svg", color: primaryColor),
              ],
            ),
            const SizedBox(height: 50.0),

            //TextField for Username
            myTextField(
              userController: userController,
              hint: 'Enter username',
              isPass: false,
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
            ),

            const SizedBox(height: 4.0),

            //TextField for Username
            myTextField(
              userController: emailController,
              hint: 'Enter email address',
              isPass: false,
              inputAction: TextInputAction.next,
              inputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 4.0),

            //TexField for Password
            myTextField(
              userController: passController,
              hint: 'Enter password',
              isPass: true,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
            ),

            const SizedBox(height: 16.0),

            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: signup,
                    style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40.0)),
                    child: const Text('Sign up'),
                  ),

            const SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                GestureDetector(
                  onTap: toLogin,
                  child: const Text('Sign in'),
                )
              ],
            ),

            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }
}
