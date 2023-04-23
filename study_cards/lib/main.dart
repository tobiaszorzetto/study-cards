
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/firebase_options.dart';
import 'package:study_cards/views/folders_view.dart';
import 'models/folder_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FileManager.instance.loadFromFirestone("General/General", FolderModel.instance);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FolderPage(folder: FolderModel.instance),
      theme: ThemeData.dark(),
    );
  }
}
