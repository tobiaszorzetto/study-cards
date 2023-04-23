
import 'dart:typed_data';

class CardModel {
  String frontDescription;
  String backDescription;

  Uint8List? frontCardData;
  Uint8List? backCardData;

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