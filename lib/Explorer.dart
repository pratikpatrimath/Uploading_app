import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('List of photos')),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('photo').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Text('No data');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Image.network(
                                          snapshot.data!.docs[index]['url'])),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Colors.indigo.shade100),
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                          snapshot.data!.docs[index]['title'])),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                      // return ListTile(
                      //   title: AspectRatio(
                      //       aspectRatio: 1 / 1,
                      //       child: Image.network(
                      //           snapshot.data!.docs[index]['url'])),
                      //   subtitle: Text(snapshot.data!.docs[index]['title']),
                      // );
                    });
              }),
        ));
  }
}
