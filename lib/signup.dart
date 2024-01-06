import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigle/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Username',
                )),
            const SizedBox(height: 10),
            TextFormField(
                controller: _mailAddressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Mail Address',
                )),
            const SizedBox(height: 10),
            TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password',
                )),
            const SizedBox(height: 10),
            SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: _mailAddressController.text,
                                password: _passwordController.text);
                        if (userCredential.user != null) {
                          var data = {
                            'username': _usernameController.text,
                            'email': _mailAddressController.text,
                            'password': _passwordController.text,
                          };
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .set(data);
                        }
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Signup'))),
          ],
        ),
      ),
    );
  }
}
