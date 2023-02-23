import 'package:study_cards/models/card_model.dart';

class FolderModel{
  String name;
  FolderModel? parentFolder;
  List<FolderModel> subFolders= [];
  List<CardModel> cards = [];


  static FolderModel instance = FolderModel(name: "General");

  FolderModel({required this.name, this.parentFolder});

  List<dynamic >getSubfolderJson(){
    List<dynamic> subs = [];
    for(FolderModel subfolder in subFolders ){
      var subJson = subfolder.toJson();
      subs.add(subJson);
    }
    return subs;
  }

  Map toJson() =>{
    "name": name,
    "parentFolder": parentFolder?.name,
    "subfolders":  subFolders.map((e) => e.toJson()).toList(),
    "cards": cards.map((e) => e.toJson()).toList()
  };

  factory FolderModel.fromJson(dynamic json, FolderModel? parentFolder){

    var cardsObjsJson = json["cards"] as List;
    List<CardModel> newCards = cardsObjsJson.map((e) => CardModel.fromJson(e)).toList();


    FolderModel newFolder = FolderModel(name: json["name"], parentFolder: parentFolder);
    var subfoldersObjsJson = json["subfolders"] as List;
    List<FolderModel> newSubfolders = subfoldersObjsJson.map((e) => FolderModel.fromJson(e, newFolder)).toList();
    newFolder.cards = newCards;
    newFolder.subFolders = newSubfolders;
    return newFolder;
  }
}