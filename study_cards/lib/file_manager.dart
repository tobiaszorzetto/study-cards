import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    var subFoldersCollection = await FirebaseFirestore.instance.collection("$path/subfolders").orderBy("name").get();
    var cardsCollection = await FirebaseFirestore.instance.collection("$path/cards").orderBy("frontDescription").get();
    for(var subfolderDocument in subFoldersCollection.docs){
      FolderModel newFolder = FolderModel(name: subfolderDocument["name"]);
      newFolder.parentFolder = folder;
      folder.subFolders.add(newFolder);
      loadFromFirestone(subfolderDocument.reference.path, newFolder);
    }
    for(var cardDocument in cardsCollection.docs){
      CardModel newCard = CardModel(frontDescription: cardDocument["frontDescription"], backDescription: cardDocument["backDescription"]);
      newCard.timeToStudy = DateTime.fromMillisecondsSinceEpoch(cardDocument["timeToStudy"]);
      var refStr = "${FileManager.instance.getFolderImagePath(folder)}/${newCard.frontDescription}";
      var frontCardReference = FirebaseStorage.instance.ref("$refStr/0.png");
      var backCardReference = FirebaseStorage.instance.ref("$refStr/1.png");
      newCard.frontCardData = await frontCardReference.getData();
      newCard.backCardData = await backCardReference.getData();

      folder.cards.add(newCard);
    }
  }

  Future<void> createCardFirestore(FolderModel folder, CardModel newCard) async {
    String path = getSubfoldersFirestorePath(folder).substring(0,getSubfoldersFirestorePath(folder).length - 10);
    var collection = FirebaseFirestore.instance.collection("${path}cards");
    collection.doc(newCard.frontDescription).set({
      "frontDescription": newCard.frontDescription,
      "backDescription": newCard.backDescription,
      "timeToStudy": newCard.timeToStudy.millisecondsSinceEpoch,
    });
  }

  Future<void> createFolderFirestore(FolderModel folder) async {
    String path = getCardsFirestorePath(folder.parentFolder);
    var collection = FirebaseFirestore.instance.collection(path);
    collection.doc(folder.name).set({
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
    var collection = await FirebaseFirestore.instance.collection("${path}cards");
    collection.doc(card.frontDescription).delete();
  }

  Future<void> deleteFolderFirestore(FolderModel folder) async{
    String path = getSubfoldersFirestorePath(folder).substring(0,getSubfoldersFirestorePath(folder).length - 11);
    var cardsCollection = await FirebaseFirestore.instance.collection("$path/cards").orderBy("frontDescription").get();
    var cardsCollection2 = FirebaseFirestore.instance.collection("$path/cards");
    for(var cardDocument in cardsCollection.docs){
      cardsCollection2.doc(cardDocument.id).delete();
    }
    for(FolderModel subfolder in folder.subFolders){
      deleteFolderFirestore(subfolder);
    }
    await FirebaseFirestore.instance.doc(path).delete();
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
      return 'images';
    } else{
      return "${getFolderImagePath(folder.parentFolder)}/${folder.name}";
    }
  }

}