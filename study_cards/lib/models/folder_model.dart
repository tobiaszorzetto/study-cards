import 'package:study_cards/models/card_model.dart';

class FolderModel{
  String name;
  FolderModel? parentFolder;
  List<FolderModel> subFolders= [];
  List<CardModel> cards = [];


  static FolderModel instance = FolderModel(name: "General");

  FolderModel({required this.name, this.parentFolder});

  
}