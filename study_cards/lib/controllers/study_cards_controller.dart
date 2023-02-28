import 'package:flutter/cupertino.dart';

import '../models/card_model.dart';
import '../models/folder_model.dart';

class StudyCardsController{
  int indexCardShowing = 0;
  int maxIndex = 0;
  FolderModel folder;
  List<CardModel> cardsToStudy;
  bool showAnswer = false;
  ScrollController scrollController = ScrollController();
  List<int> cardsStudied = [];
  

  StudyCardsController(this.folder,this.cardsToStudy){
    maxIndex = cardsToStudy.length - 1 ;
  }

  nextCard(){
    if(cardsStudied.length == cardsToStudy.length){
      return;
    }
    showAnswer = false;
    if(indexCardShowing != maxIndex){
      indexCardShowing++;
      if(cardsStudied.contains(indexCardShowing)){
        nextCard();
      }
    }else{
      indexCardShowing = 0;
      if(cardsStudied.contains(indexCardShowing)){
        nextCard();
      }
    }
  }

  void lastCard() {
    if(cardsStudied.length == cardsToStudy.length){
      return;
    }
    showAnswer = false;
    if(indexCardShowing != 0){
      indexCardShowing--;
      if(cardsStudied.contains(indexCardShowing)){
        nextCard();
      }
    }else{
      indexCardShowing = indexCardShowing;
      if(cardsStudied.contains(indexCardShowing)){
        nextCard();
      }
    }
  }
}