import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/screens/signup_screen.dart';
import 'package:instadrop/utilities/constants.dart';

import '../methods/other_methods.dart';
import '../utilities/myTextField.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  bool isLoading = false;

  void toSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  void toHomeScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    String res = await FireMethods().login(
        email: emailController.text.trim().toLowerCase(),
        password: passController.text.trim().toLowerCase());
    if (res == 'success') {
      toHomeScreen();
    } else {
      // ignore: use_build_context_synchronously
      showSnack(content: res, context: context);
    }
    setState(() {
      isLoading = false;
    });
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
                userController: emailController,
                hint: 'Enter email address',
                isPass: false,
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next),

            const SizedBox(height: 4.0),

            //TexField for Password
            myTextField(
                userController: passController,
                hint: 'Enter password',
                isPass: true,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done),

            const SizedBox(height: 16.0),

            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: login,
                    style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40.0)),
                    child: const Text('Log in'),
                  ),
            const SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: toSignup,
                  child: const Text('Sign up'),
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
