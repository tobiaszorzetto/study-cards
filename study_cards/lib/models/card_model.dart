import 'dart:typed_data';

import 'dart:typed_data';

class CardModel {
  String frontDescription;
  String backDescription;

  Uint8List? frontCardData;
  Uint8List? backCardData;

  bool hasFront;
  bool hasBack;

  DateTime timeToStudy = DateTime.now();

  CardModel({required this.frontDescription, required this.backDescription, required this.hasBack, required this.hasFront});

  
  Map toJson() => {
    "frontDescription": frontDescription,
    "backDescription": backDescription,
    "timeToStudy": timeToStudy.millisecondsSinceEpoch,
    "hasFront": hasFront,
    "hasBack": hasBack,
  };

  factory CardModel.fromJson(dynamic json){
    CardModel newCard =  CardModel(frontDescription: json["frontDescription"], backDescription: json["backDescription"], hasFront: json["hasFront"], hasBack: json["hasBack"]);
    newCard.timeToStudy = DateTime.fromMillisecondsSinceEpoch(json["timeToStudy"]);
    return newCard;
  }

}