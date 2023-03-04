import 'dart:convert';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_cards/models/folder_model.dart';

class FileManager {

  static FileManager instance = FileManager();

  Future<String> getPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveFolderFirestone(String name) async {
    var colecao = await Firestore.instance.collection(getSubfoldersFirestonePath(FolderModel.instance));
    print(colecao);
  }

  Future<void> createFolderFirestone(FolderModel folder) async {
    String path = getSubfoldersFirestonePath(folder.parentFolder);
    var collection = await Firestore.instance.collection(path);
    collection.document(folder.name).set({
      "name": folder.name,
    });
  }

  String getSubfoldersFirestonePath(FolderModel? folder){
    if(folder == null){
      return "General";
    } else{
      return "${getSubfoldersFirestonePath(folder.parentFolder)}/${folder.name}/subfolders";
    }
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

  String getFolderImagePath(FolderModel? folder){
    if(folder == null){
      return 'assets\\images';
    } else{
      return "${getFolderImagePath(folder.parentFolder)}\\${folder.name}";
    }
  }

}