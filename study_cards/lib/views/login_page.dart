import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/create_account_page.dart';
import 'package:study_cards/views/folders_view.dart';

import '../file_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/4,
          height: MediaQuery.of(context).size.height/2,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(child: Image.asset("assets/images/logo.png")),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "password"),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                  onPressed: () => setState(() {
                        signIn();
                      }),
                  child: Text("Sign in")),
              ElevatedButton(
                  onPressed: () => setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateAccount(),
                          ),
                        );
                      }),
                  child: Text("Create account")),
            ]),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    var user = FirebaseAuth.instance.currentUser!;
    print(user.uid);
    await FileManager.instance.loadFromFirestone(
        "${user.uid}/General", FolderModel.instance, user.uid);
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FolderPage(folder: FolderModel.instance, user: user),
      ),
    );
  }

}
