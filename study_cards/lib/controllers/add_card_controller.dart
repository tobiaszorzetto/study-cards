import 'dart:io';
import 'dart:typed_data';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

import '../file_manager.dart';
import '../models/card_model.dart';
import '../models/folder_model.dart';

class AddCardController{
  late ScribbleNotifier notifierFront;
  late ScribbleNotifier notifierBack;
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();
  double stroke = 1;
  
  bool eraseSelected = false;

  bool showFrontSide = true;

  late AnimationController animationController;
  late Animation animation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;

  Color drawingColor = Colors.black;

  FolderModel folder;

  ByteData? imageFront;
  ByteData? imageBack;

  bool showImageBack = false; 
  bool showImageFront = false; 

  bool highlightFrontText = false;

  bool createCardValidated = true;

  FlipCardController flipCardController = FlipCardController();

  AddCardController(this.folder);

  bool validateCard(){
    if(folder.cards.map((e) => e.frontDescription).contains(frontTextController.text)){
      createCardValidated = false;
      return false;
    }
    createCardValidated = true;
    return true;
  }

  Future<void> changeCardSide() async{
    updateImage();
    await flipCardController.toggleCard();
    showFrontSide = !showFrontSide;
  }

  Future<void> updateImage() async{
    if (animationStatus == AnimationStatus.dismissed) {
      if(showImageFront){
        imageFront = await notifierFront.renderImage();   
      }
    } else {
      if(showImageBack){
        imageBack = await notifierBack.renderImage();   
      }
    }
  }

  Future<void> _saveImages() async {
    await updateImage();

    if(imageFront != null && showImageFront){
      File fileFront = File("${FileManager.instance.getFolderImagePath(folder)}\\${frontTextController.text.replaceAll(RegExp('[^A-Za-z0-9]'), '')}0");
      fileFront.writeAsBytes(imageFront!.buffer.asUint8List());  
    }
    if(imageBack != null && showImageBack){
      File fileBack = File("${FileManager.instance.getFolderImagePath(folder)}\\${frontTextController.text.replaceAll(RegExp('[^A-Za-z0-9]'), '')}1");
      fileBack.writeAsBytes(imageBack!.buffer.asUint8List()); 
    }

  }

  addCard(){
    _saveImages();
    folder.cards.add(CardModel(frontDescription: frontTextController.text, backDescription: backTextController.text));
    FileManager.instance.saveCards();
  }


  
}