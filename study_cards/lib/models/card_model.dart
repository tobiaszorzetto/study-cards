import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

class CardModel {
  String frontDescription;
  String backDescription;

  DateTime timeToStudy = DateTime.now();

  CardModel({required this.frontDescription, required this.backDescription,});

  
  Map toJson() => {
    "frontDescription": frontDescription,
    "backDescription": backDescription,
    "timeToStudy": timeToStudy.millisecondsSinceEpoch,
  };

  factory CardModel.fromJson(dynamic json){
    CardModel newCard =  CardModel(frontDescription: json["frontDescription"], backDescription: json["backDescription"], );
    newCard.timeToStudy = DateTime.fromMillisecondsSinceEpoch(json["timeToStudy"]);
    return newCard;
  }

}