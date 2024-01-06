import 'package:epigle/Explorer.dart';
import 'package:epigle/videopage.dart';
import 'package:flutter/material.dart';

class Retrive extends StatefulWidget {
  const Retrive({super.key});

  @override
  State<Retrive> createState() => _RetriveState();
}

class _RetriveState extends State<Retrive> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          Explorer(),
          VideoPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Photos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_camera_back_rounded), label: 'Videos'),
        ],
      ),
    );
  }
}
