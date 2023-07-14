import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/methods/other_methods.dart';
import 'package:instadrop/screens/home_screen.dart';

import '../utilities/myTextField.dart';

class BioSignup extends StatefulWidget {
  const BioSignup({super.key});

  @override
  State<BioSignup> createState() => _BioSignupState();
}

class _BioSignupState extends State<BioSignup> {
  final TextEditingController bioController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

  pickImage() {
    setState(() async {
      image = await OtherMethods().selectImage(ImageSource.gallery);
    });
  }

  void toHomeScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void bioSignUp() async {
    setState(() {
      isLoading = true;
    });
    String res = await FireMethods()
        .bioSignUp(bio: bioController.text.trim().toLowerCase(), file: image!);
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
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 100.0),

            // Circular Avatar with stacked Image Picker

            Stack(
              children: [
                image != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(image!),
                        radius: 60.0,
                      )
                    : const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        radius: 60.0,
                      ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: pickImage,
                        iconSize: 30.0,
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),

            const SizedBox(height: 36.0),

            //TextField for Username
            myTextField(
                userController: bioController,
                hint: 'Enter user bio',
                isPass: false,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done),

            const SizedBox(height: 16.0),

            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: bioSignUp,
                    style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40.0)),
                    child: const Text('Finish'),
                  ),
          ],
        ),
      ),
    );
  }
}
