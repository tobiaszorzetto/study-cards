import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/models/folder_model.dart';

class FileManager {

  static FileManager instance = FileManager();

  Future<void> loadFromFirestone(String path, FolderModel folder, String uid) async{
    var subFoldersCollection = await FirebaseFirestore.instance.collection("$path/subfolders").orderBy("name").get();
    var cardsCollection = await FirebaseFirestore.instance.collection("$path/cards").orderBy("frontDescription").get();
    for(var subfolderDocument in subFoldersCollection.docs){
      FolderModel newFolder = FolderModel(name: subfolderDocument["name"]);
      newFolder.parentFolder = folder;
      folder.subFolders.add(newFolder);
      loadFromFirestone(subfolderDocument.reference.path, newFolder, uid);
    }
    for(var cardDocument in cardsCollection.docs){
      CardModel newCard = CardModel(frontDescription: cardDocument["frontDescription"], backDescription: cardDocument["backDescription"], hasBack: cardDocument["hasBack"], hasFront: cardDocument["hasFront"]);
      newCard.timeToStudy = DateTime.fromMillisecondsSinceEpoch(cardDocument["timeToStudy"]);
      var refStr = "${FileManager.instance.getFolderImagePath(folder, uid)}/${newCard.frontDescription}";
      var frontCardReference = FirebaseStorage.instance.ref("$refStr/0.png");
      var backCardReference = FirebaseStorage.instance.ref("$refStr/1.png");

      if(newCard.hasFront) newCard.frontCardData = await frontCardReference.getData();
      if(newCard.hasBack) newCard.backCardData = await backCardReference.getData();

      folder.cards.add(newCard);
    }
  }

  Future<void> updateTimeToStudy(FolderModel folder, CardModel newCard, String uid) async {
    String path = getSubfoldersFirestorePath(folder, uid).substring(0,getSubfoldersFirestorePath(folder, uid).length - 10);
    var collection = FirebaseFirestore.instance.collection("${path}cards");
    collection.doc(newCard.frontDescription).update({
      "timeToStudy": newCard.timeToStudy.millisecondsSinceEpoch,
    });
  }

  Future<void> createCardFirestore(FolderModel folder, CardModel newCard, String uid) async {
    String path = getSubfoldersFirestorePath(folder, uid).substring(0,getSubfoldersFirestorePath(folder, uid).length - 10);
    var collection = FirebaseFirestore.instance.collection("${path}cards");
    collection.doc(newCard.frontDescription).set({
      "frontDescription": newCard.frontDescription,
      "backDescription": newCard.backDescription,
      "timeToStudy": newCard.timeToStudy.millisecondsSinceEpoch,
      "hasBack": newCard.hasBack,
      "hasFront": newCard.hasFront,
    });
  }

  Future<void> createFolderFirestore(FolderModel folder, String uid) async {
    String path = getSubfoldersFirestorePath(folder.parentFolder, uid);
    var collection = FirebaseFirestore.instance.collection(path);
    await collection.doc(folder.name).set({
      "name": folder.name,
    });
  }

  String getSubfoldersFirestorePath(FolderModel? folder, String uid){
    if(folder == null){
      return uid;
    } else{
      return "${getSubfoldersFirestorePath(folder.parentFolder, uid)}/${folder.name}/subfolders";
    }
  }
  String getCardsFirestorePath(FolderModel? folder, String uid){
    if(folder == null){
      return uid;
    } else{
      return "${getSubfoldersFirestorePath(folder.parentFolder, uid)}/${folder.name}/cards";
    }
  }

  Future<void> deleteCardFirestore(FolderModel folder, CardModel card, String uid) async{
    String path = getSubfoldersFirestorePath(folder, uid).substring(0,getSubfoldersFirestorePath(folder, uid).length - 10);
    var collection = FirebaseFirestore.instance.collection("${path}cards");
    collection.doc(card.frontDescription).delete();
  }

  Future<void> deleteFolderFirestore(FolderModel folder, String uid) async{
    String path = getSubfoldersFirestorePath(folder, uid).substring(0,getSubfoldersFirestorePath(folder, uid).length - 11);
    var cardsCollection = await FirebaseFirestore.instance.collection("$path/cards").orderBy("frontDescription").get();
    var cardsCollection2 = FirebaseFirestore.instance.collection("$path/cards");
    for(var cardDocument in cardsCollection.docs){
      cardsCollection2.doc(cardDocument.id).delete();
    }
    for(FolderModel subfolder in folder.subFolders){
      deleteFolderFirestore(subfolder, uid);
    }
    await FirebaseFirestore.instance.doc(path).delete();
  }

  String getFolderImagePath(FolderModel? folder, String uid){
    if(folder == null){
      return 'users/$uid/images';
    } else{
      return "${getFolderImagePath(folder.parentFolder, uid)}/${folder.name}";
    }
  }

}