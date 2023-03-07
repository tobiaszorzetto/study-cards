import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/controllers/add_card_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/folders_view.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  TextEditingController emailController = TextEditingController(text:"");
  TextEditingController passwordController = TextEditingController(text:"");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "password"),
            ), 
            ElevatedButton(
              onPressed: () => setState(() {
                signIn();
              }), 
              child: Text("Sign in")
            ),
          ]
        ),
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance.signIn(emailController.text, passwordController.text);
    var user = await FirebaseAuth.instance.getUser();
    print(user);
    Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FolderPage(folder: FolderModel.instance),
            ),
          );
  }

}
