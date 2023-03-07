import 'dart:io';

import 'package:flutter/widgets.dart';

import '../file_manager.dart';
import '../models/card_model.dart';
import '../models/folder_model.dart';

class FolderController{

  bool showBack = false;
  FolderModel folder;

  late File frontCardFile;
  late File backCardFile;
  late bool frontCardExists;
  late bool backCardExists;

  TextEditingController folderCreateNameController = TextEditingController(text: "");
  bool folderCreateValidated = true;
  int cardDificulty = 0 ;
  Duration timeToStudy = const Duration(minutes:0);

  
  List<CardModel> cardsToStudy = [];

  FolderController(this.folder);

  ScrollController scrollController = ScrollController();

  // CREATE

  bool validateFolder(){
    if(folder.subFolders.map((e) => e.name).toList().contains(folderCreateNameController.text)){
      folderCreateValidated = false;
      return false;
    }
    folderCreateValidated = true;
    return true;
  }

  void createFolder(){
    FolderModel newSubFolder = FolderModel(name: folderCreateNameController.text, parentFolder: folder);
    folder.subFolders.add(newSubFolder);
    Directory(FileManager.instance.getFolderImagePath(newSubFolder)).create();
    FileManager.instance.createFolderFirestore(newSubFolder);
    FileManager.instance.saveCards();
    folderCreateNameController.text = "";
    folderCreateValidated = true;
  }

  void setCardsToStudy(){
    cardsToStudy = [];
    for(CardModel card in folder.cards){
      if(card.timeToStudy.compareTo(DateTime.now())<=0){
        cardsToStudy.add(card);
      }
    }
  }

  void createTimeToStudy(CardModel card){
      card.timeToStudy = DateTime.now().add(timeToStudy);
      FileManager.instance.saveCards();
      setCardsToStudy();
  }
  
    //DELETE

  Future<void> _deleteImages(CardModel card, FolderModel folder) async{
    String folderPath = FileManager.instance.getFolderImagePath(folder);
    File file0 = File("$folderPath\\${card.frontDescription}0");
    File file1 = File("$folderPath\\${card.frontDescription}1");
    if(await file0.exists()){
      file0.delete();
    }
    if(await file1.exists()){
      file1.delete();
    }
  }

  void deleteCard(int cardIndex) {
    _deleteImages(folder.cards[cardIndex], folder);
    FileManager.instance.deleteCardFirestore(folder, folder.cards[cardIndex]);
    folder.cards.remove(folder.cards[cardIndex]);

    FileManager.instance.saveCards();
  }

  Future<void> _deleteFolder(FolderModel folderDeleted) async{
    for (FolderModel subfolder in folderDeleted.subFolders){
      await _deleteFolder(subfolder);
    }
    for(CardModel card in folderDeleted.cards){
      await _deleteImages(card, folderDeleted);
    }
    await Directory(FileManager.instance.getFolderImagePath(folderDeleted)).delete();

  }

  deleteSubfolder(int subfolderIndex){
    //_deleteFolder(folder.subFolders[subfolderIndex]);
    FileManager.instance.deleteFolderFirestore(folder.subFolders[subfolderIndex]);
    folder.subFolders.remove(folder.subFolders[subfolderIndex]);
    FileManager.instance.saveCards();
  }

  // SHOW

    String showDificultyLabel() {
    if (cardDificulty == 0) {
      return "Easy";
    } else if (cardDificulty == 1) {
      return "Medium";
    } else if (cardDificulty == 2) {
      return "Hard";
    }
    return "Try Again";
  }

  Future<void> prepareImages(CardModel card) async {
    String folderPath = FileManager.instance.getFolderImagePath(folder);
    frontCardFile = File("$folderPath\\${card.frontDescription}0");
    frontCardExists = await frontCardFile.exists(); 
    backCardFile = File("$folderPath\\${card.frontDescription}1");
    backCardExists = await backCardFile.exists(); 
  }

  void setTimeToStudy(){
    if(cardDificulty == 0){
      const timeToStudy = Duration(days: 6);
    } else if(cardDificulty == 1){
      const timeToStudy = Duration(days: 1);
    } else if(cardDificulty == 2){
      const timeToStudy = Duration(minutes: 10);
    } else{
      const timeToStudy = Duration(minutes: 0);
    }
  }
  
}