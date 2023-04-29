import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:scribble/scribble.dart';

import '../file_manager.dart';
import '../models/card_model.dart';
import '../models/folder_model.dart';

class AddCardController{
  User user;

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

  Uint8List? imageFront;
  Uint8List? imageBack;

  bool showImageBack = false; 
  bool showImageFront = false; 

  bool hasFront = false;
  bool hasBack = false;

  bool highlightFrontText = false;

  PainterController frontPainterController = PainterController();
  PainterController backPainterController = PainterController();

  AddCardController(this.folder, this.user){
    frontPainterController.freeStyleMode = FreeStyleMode.draw;
    stroke = frontPainterController.freeStyleStrokeWidth;
    backPainterController.freeStyleMode = FreeStyleMode.draw;
    stroke = backPainterController.freeStyleStrokeWidth;

  }

  void changeCardSide(BuildContext context){
    updateImage(context);
    if (animationStatus == AnimationStatus.dismissed) {
      showFrontSide = false;
      animationController.forward();
    } else {
      showFrontSide = true;
      animationController.reverse();
    }
  }

  Future<void> updateImage(BuildContext context) async{
    if (animationStatus == AnimationStatus.dismissed) {
      if(showImageFront){
        imageFront = await frontPainterController.renderImage(Size(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2)).then<Uint8List?>((ui.Image image) => image.pngBytes);   
      }
    } else {
      if(showImageBack){
        imageBack = await backPainterController.renderImage(Size(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2)).then<Uint8List?>((ui.Image image) => image.pngBytes);    
      }
    }
  }

 Future<void> _saveImages(BuildContext context) async {
    await updateImage(context);
    var storageRef = FirebaseStorage.instance.ref();
    var imagesRef = storageRef.child("${FileManager.instance.getFolderImagePath(folder, user.uid)}/${frontTextController.text}");
    if(imageFront != null && showImageFront){
      hasFront = true;
      await imagesRef.child("0.png").putData(imageFront!.buffer.asUint8List()); 
    }
    if(imageBack != null && showImageBack){
      hasBack = true;
      await imagesRef.child("1.png").putData(imageBack!.buffer.asUint8List());
    }

  }

Future<void> addCard(BuildContext context) async{
    await _saveImages(context);
    var newCard = CardModel(frontDescription: frontTextController.text, backDescription: backTextController.text, hasBack: hasBack, hasFront: hasFront);
    if(hasBack) newCard.backCardData = imageBack!.buffer.asUint8List();
    if(hasFront) newCard.frontCardData = imageFront!.buffer.asUint8List();
    folder.cards.add(newCard);
    FileManager.instance.createCardFirestore(folder, newCard,user.uid);
  }
  
}