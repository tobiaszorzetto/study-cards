import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/folders_view.dart';

class CreateAccount extends StatefulWidget {
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>{
  TextEditingController emailController = TextEditingController(text:"");
  TextEditingController passwordController = TextEditingController(text:"");
  TextEditingController confirmPasswordController = TextEditingController(text:"");
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
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: "confirm password"),
            ), 
            ElevatedButton(
              onPressed: () => setState(() {
                createUser();
              }), 
              child: Text("Create account")
            ),
          ]
        ),
      ),
    );
  }

  Future createUser() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      var user = FirebaseAuth.instance.currentUser;
      Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FolderPage(folder: FolderModel.instance, user: user!,),
            ),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

}
