import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
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

  AddCardController(this.folder);

  void changeCardSide(){
    updateImage();
    if (animationStatus == AnimationStatus.dismissed) {
      showFrontSide = false;
      animationController.forward();
    } else {
      showFrontSide = true;
      animationController.reverse();
    }
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
    var storageRef = FirebaseStorage.instance.ref();
    var imagesRef = storageRef.child("${FileManager.instance.getFolderImagePath(folder)}/${frontTextController.text}");
    if(imageFront != null && showImageFront){
      await imagesRef.child("0.png").putData(imageFront!.buffer.asUint8List()); 
    }
    if(imageBack != null && showImageBack){
      await imagesRef.child("1.png").putData(imageBack!.buffer.asUint8List());
    }

  }

  addCard(){
    _saveImages();
    var newCard = CardModel(frontDescription: frontTextController.text, backDescription: backTextController.text);
    newCard.backCardData = imageBack!.buffer.asUint8List();
    newCard.frontCardData = imageFront!.buffer.asUint8List();
    folder.cards.add(newCard);
    FileManager.instance.createCardFirestore(folder, newCard);
    FileManager.instance.saveCards();
  }
  
}