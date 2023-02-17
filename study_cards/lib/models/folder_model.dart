import 'package:study_cards/models/card_model.dart';

class FolderModel{
  String name;
  List<FolderModel> subFolders= [];
  List<CardModel> cards = [];

  FolderModel({required this.name});

  static FolderModel instance = FolderModel(name: "General");

  
}