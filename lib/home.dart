import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigle/login.dart';
import 'package:epigle/retrive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _photocontroller() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      await _uploadFile(photo, 'photo');
      print('photo uploaded');
      _titleController.clear();
    }
  }

  Future<void> _videocontroller() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      await _uploadFile(video, 'video');
      print('video uploaded');
      _titleController.clear();
    }
  }

  Future<void> _uploadFile(XFile file, String folderName) async {
    File fileToUpload = File(file.path);
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('$folderName/${DateTime.now().toIso8601String()}')
          .putFile(fileToUpload);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection(folderName).add({
        'title': _titleController.text,
        'url': downloadUrl,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            child: const Text('signout'),
          ),
        ),
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Title',
                  ),
                ),
                ElevatedButton(
                    onPressed: _photocontroller,
                    child: const Text('Take picture')),
                ElevatedButton(
                    onPressed: _videocontroller,
                    child: const Text('Take video')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Retrive()));
                    },
                    child: const Text('See photos and videos')),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Some Intructions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'This app check that you are previously logged in or not. If you logged in then it will open directly home page. You dont need to login every time. It takes some time to upload the photo or video When the upload is complete,the textbox will be cleared.',
                ),
                const Text(
                    'It takes some time to render photos and videos. To signout,open the drawer which is on home page at top left corner and click on signout.'),
              ],
            ),
          ),
        ));
  }
}
