import 'dart:convert';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/models/folder_model.dart';

class FileManager {

  static FileManager instance = FileManager();

  Future<String> getPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> loadFromFirestone(String path, FolderModel folder) async{
        
    CollectionReference subFoldersCollection = Firestore.instance.collection("$path/subfolders");
    CollectionReference cardsCollection = Firestore.instance.collection("$path/cards");
    for(Document subfolderDocument in await subFoldersCollection.orderBy("name").get()){
      FolderModel newFolder = FolderModel(name: subfolderDocument["name"]);
      newFolder.parentFolder = folder;
      folder.subFolders.add(newFolder);
      loadFromFirestone(subfolderDocument.path, newFolder);
    }
    for(Document cardDocument in await cardsCollection.orderBy("frontDescription").get()){
      CardModel newCard = CardModel(frontDescription: cardDocument["frontDescription"], backDescription: cardDocument["backDescription"]);
      newCard.timeToStudy = DateTime.fromMillisecondsSinceEpoch(cardDocument["timeToStudy"]);
      folder.cards.add(newCard);
    }

  }

  Future<void> createCardFirestore(FolderModel folder, CardModel newCard) async {
    String path = getSubfoldersFirestorePath(folder).substring(0,getSubfoldersFirestorePath(folder).length - 10);
    var collection = await Firestore.instance.collection("${path}cards");
    collection.document(newCard.frontDescription).set({
      "frontDescription": newCard.frontDescription,
      "backDescription": newCard.backDescription,
      "timeToStudy": newCard.timeToStudy.millisecondsSinceEpoch,
    });
  }

  Future<void> createFolderFirestore(FolderModel folder) async {
    String path = getCardsFirestorePath(folder.parentFolder);
    var collection = await Firestore.instance.collection(path);
    collection.document(folder.name).set({
      "name": folder.name,
      
    });
  }

  String getSubfoldersFirestorePath(FolderModel? folder){
    if(folder == null){
      return "General";
    } else{
      return "${getSubfoldersFirestorePath(folder.parentFolder)}/${folder.name}/subfolders";
    }
  }
  String getCardsFirestorePath(FolderModel? folder){
    if(folder == null){
      return "General";
    } else{
      return "${getSubfoldersFirestorePath(folder.parentFolder)}/${folder.name}/subfolders";
    }
  }

  Future<void> deleteCardFirestore(FolderModel folder, CardModel card) async{
    String path = getSubfoldersFirestorePath(folder).substring(0,getSubfoldersFirestorePath(folder).length - 10);
    var collection = await Firestore.instance.collection("${path}cards");
    collection.document(card.frontDescription).delete();
  }

  Future<void> deleteFolderFirestore(FolderModel folder) async{
    String path = getSubfoldersFirestorePath(folder).substring(0,getSubfoldersFirestorePath(folder).length - 11);
    var cardsCollection = Firestore.instance.collection("$path/cards");
    for(Document cardDocument in await cardsCollection.orderBy("frontDescription").get()){
      cardsCollection.document(cardDocument.id).delete();
    }
    for(FolderModel subfolder in folder.subFolders){
      deleteFolderFirestore(subfolder);
    }


    await Firestore.instance.document(path).delete();
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