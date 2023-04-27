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
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.blue, Colors.black])),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 2,
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Image.asset("assets/images/logo.png")),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "email",
                        enabledBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "password",
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.password),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "confirm password",
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.password),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF2697FF),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 80),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0))),
                        onPressed: () => setState(() {
                              createUser();
                            }),
                        child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                    ),
                    
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future createUser() async {
    if(passwordController.text != confirmPasswordController.text) return;
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
