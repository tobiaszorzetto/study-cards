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

  FolderController(this.folder);

  // CREATE

  void createFolder(){
    FolderModel newSubFolder = FolderModel(name: folderCreateNameController.text, parentFolder: folder);
    folder.subFolders.add(newSubFolder);
    Directory(FileManager.instance.getFolderImagePath(newSubFolder)).create();
    FileManager.instance.saveCards();
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
    _deleteFolder(folder.subFolders[subfolderIndex]);
    folder.subFolders.remove(folder.subFolders[subfolderIndex]);
    FileManager.instance.saveCards();
  }

  // SHOW

  Future<void> prepareImages(CardModel card) async {
    String folderPath = FileManager.instance.getFolderImagePath(folder);
    frontCardFile = File("$folderPath\\${card.frontDescription}0");
    frontCardExists = await frontCardFile.exists(); 
    backCardFile = File("$folderPath\\${card.frontDescription}1");
    backCardExists = await backCardFile.exists(); 
  }
}