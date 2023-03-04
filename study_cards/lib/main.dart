
import 'package:flutter/material.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/views/folders_view.dart';
import 'models/folder_model.dart';
import 'package:firedart/firedart.dart';

const apiKey = "AIzaSyBR1klsp8TetdxgLP1_QHkTIhIhiw2We94";
const projectId = "studycards-e3d50";
void main() async {
  Firestore.initialize(projectId);
  WidgetsFlutterBinding.ensureInitialized();
  await FileManager.instance.loadCards();
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
