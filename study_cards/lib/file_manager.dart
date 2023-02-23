import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:study_cards/models/folder_model.dart';

class FileManager {

  static FileManager instance = FileManager();

  Future<String> getPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  Future<void> saveCards() async {
    final path = await getPath(); 
    final file = File("$path\\study-cards");
    var jsonFolder = FolderModel.instance.toJson();
    var jsonCards = jsonEncode(jsonFolder);
    await file.writeAsString(jsonCards);
  }


  Future<void> loadCards() async{
    final path = await getPath();
    final file = File("$path\\study-cards");
    if(await file.exists()){
      try {
        String fileContent = await file.readAsString();
        var cardsMap = jsonDecode(fileContent);
        FolderModel.instance = FolderModel.fromJson(cardsMap, null);
        
      } catch (e) {
        print(e);
      }
    }
  }

}