import 'package:scribble/scribble.dart';

class CardModel {
  String frontDescription;
  String backDescription;
  ScribbleNotifier frontNotifier;
  ScribbleNotifier backNotifier;

  CardModel({required this.frontDescription, required this.backDescription, required this.frontNotifier, required this.backNotifier});


}