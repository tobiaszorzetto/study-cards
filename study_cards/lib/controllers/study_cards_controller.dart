import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../file_manager.dart';
import '../models/card_model.dart';
import '../models/folder_model.dart';

class StudyCardsController {
  User user;

  int indexCardShowing = 0;
  int maxIndex = 0;
  FolderModel folder;
  List<CardModel> cardsToStudy;
  bool showAnswer = false;
  ScrollController scrollController = ScrollController();
  List<int> cardsStudied = [];
  late String folderPath;
  File? frontCardFile;
  File? backCardFile;

  StudyCardsController(this.folder, this.cardsToStudy, this.user) {
    maxIndex = cardsToStudy.length - 1;
    folderPath = FileManager.instance.getFolderImagePath(folder, user.uid);
    setImages();
  }

  nextCard() async {
    if (cardsStudied.length == cardsToStudy.length) {
      return;
    }
    showAnswer = false;
    if (indexCardShowing != maxIndex) {
      indexCardShowing++;
      if (cardsStudied.contains(indexCardShowing)) {
        nextCard();
      }
    } else {
      indexCardShowing = 0;
      if (cardsStudied.contains(indexCardShowing)) {
        nextCard();
      }
    }
    await setImages();
  }

  setImages() async {
    frontCardFile = File(
        "$folderPath\\${cardsToStudy[indexCardShowing].frontDescription}0");
    backCardFile = File(
        "$folderPath\\${cardsToStudy[indexCardShowing].frontDescription}1");
    if (!await frontCardFile!.exists()) {
      frontCardFile = null;
    }
    if (!await backCardFile!.exists()) {
      backCardFile = null;
    }
  }

  lastCard() async {
    if (cardsStudied.length == cardsToStudy.length) {
      return;
    }
    showAnswer = false;
    if (indexCardShowing != 0) {
      indexCardShowing--;
      if (cardsStudied.contains(indexCardShowing)) {
        nextCard();
      }
    } else {
      indexCardShowing = indexCardShowing;
      if (cardsStudied.contains(indexCardShowing)) {
        nextCard();
      }
    }
    await setImages();
  }

  void updateCard(Duration duration) {
    cardsToStudy[indexCardShowing].timeToStudy = DateTime.now().add(duration);
    cardsStudied.add(indexCardShowing);
    nextCard();
  }
}
