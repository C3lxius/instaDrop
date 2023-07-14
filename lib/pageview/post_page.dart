import 'dart:typed_data';
import 'package:instadrop/methods/fire_methods.dart';
import 'package:instadrop/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../methods/other_methods.dart';
import '../utilities/constants.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Uint8List? image;
  TextEditingController capController = TextEditingController();
  bool isLoading = false;

  pickImageGallery() async {
    image = await OtherMethods().selectImage(ImageSource.gallery);
    setState(() {});
  }

  pickImageCamera() async {
    image = await OtherMethods().selectImage(ImageSource.camera);
    setState(() {});
  }

  onPost({required String username, required String dp}) async {
    setState(() {
      isLoading = true;
    });
    String result = await FireMethods().uploadPost(
        file: image!,
        caption: capController.text.trim(),
        username: username,
        dp: dp);
    if (result == 'success') {
      // ignore: use_build_context_synchronously
      showSnack(content: 'Posted Successfully', context: context);
      setState(() {
        isLoading = false;
        image = null;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      // ignore: use_build_context_synchronously
      showSnack(content: result, context: context);
    }
  }

  @override
  void dispose() {
    capController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().myUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('New Post'),
        centerTitle: true,
        leading: image != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    image = null;
                  });
                },
                icon: const Icon(Icons.arrow_back))
            : const SizedBox(),
        actions: image != null
            ? [
                IconButton(
                    onPressed: () =>
                        onPost(dp: user.dp, username: user.username),
                    icon: const Icon(Icons.done)),
              ]
            : [],
      ),
      body: image == null
          ? Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                height: 230,
                width: 220,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Upload Your Pictures ${user.email}'),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: pickImageGallery,
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload from Gallery'),
                        style:
                            TextButton.styleFrom(backgroundColor: buttonColor),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton.icon(
                        onPressed: pickImageCamera,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Upload from Camera'),
                        style:
                            TextButton.styleFrom(backgroundColor: buttonColor),
                      )
                    ]),
              ),
            )
          : Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator(color: buttonColor)
                    : const SizedBox(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(user.dp),
                        radius: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: capController,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a caption...',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: AspectRatio(
                            aspectRatio: 400 / 480,
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        alignment: FractionalOffset.topCenter,
                                        image: MemoryImage(image!))))),
                      ),
                    ],
                  ),
                ),
                const Divider(color: cardColor),
              ],
            ),
    );
  }
}
