import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/views/add_card_page.dart';
import 'package:study_cards/views/folders_view.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'models/folder_model.dart';

void main() async {
  await FileManager.instance.loadCards();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:FolderPage(folder:FolderModel.instance),
      theme: ThemeData.dark(),
    );
  }
}

