import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_cards/controllers/study_cards_controller.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/views/folders_view.dart';

import '../file_manager.dart';
import '../models/folder_model.dart';

class StudyCardsPage extends StatefulWidget {
  FolderModel folder;
  List<CardModel> cardsToStudy;
  StudyCardsPage({super.key, required this.folder, required this.cardsToStudy});

  @override
  State<StudyCardsPage> createState() => _StudyCardsPageState(folder,cardsToStudy);
}

class _StudyCardsPageState extends State<StudyCardsPage>{

  late StudyCardsController controller;

  _StudyCardsPageState(folder,cardsToStudy){
    controller = StudyCardsController(folder, cardsToStudy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            Navigator.of(context).pop;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FolderPage(folder: controller.folder)
            ));
          }),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => setState(() {
              controller.lastCard();
            }), 
            icon: const Icon(Icons.arrow_back_ios_new)
          ),
          controller.cardsToStudy.length != controller.cardsStudied.length? _showCard() : const Text("No more cards to study"),
          IconButton(
            onPressed: () => setState(() {
              controller.nextCard();
            }),  
            icon: const Icon(Icons.arrow_forward_ios)
          ),
        ],
      ),
    );
  }

  Widget _showCard(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height/1.5,
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.showAnswer? _showBack():_showFront()
            ],
          ),
        ),
      ],
    );
  }

  Visibility _showBack() {
    return Visibility(
                visible: controller.showAnswer,
                child: Expanded(
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              controller.showAnswer = !controller.showAnswer;
                            }), 
                            child: const Icon(Icons.arrow_upward)
                          ),
                        ),
                        Expanded(flex: 10,child: _showImageInDialog(controller.backCardFile, controller.cardsToStudy[controller.indexCardShowing],controller.cardsToStudy[controller.indexCardShowing].backDescription)),
                        Expanded(flex: 2,child: _showDificultyOptions())
                      ],
                    ),
                  ),
                ),
              );
  }

  Visibility _showFront() {
    return Visibility(
                visible: !controller.showAnswer,
                child: Expanded(
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 16, child: _showImageInDialog(controller.frontCardFile, controller.cardsToStudy[controller.indexCardShowing],controller.cardsToStudy[controller.indexCardShowing].frontDescription)),
                        Expanded(flex: 1,
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              controller.showAnswer = !controller.showAnswer;
                            }), 
                            child: const Icon(Icons.arrow_downward)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  Row _showDificultyOptions() {
    return Row(
      children: [
        _dificulltyButton(const Duration(minutes: 0), "Try again", "0 min"),
        _dificulltyButton(const Duration(minutes: 10), "Hard", "10 min"),
        _dificulltyButton(const Duration(days: 1), "Medium", "1 day"),
        _dificulltyButton(const Duration(days: 6), "Easy", "6 days"),
      ],
    );
  }

  Expanded _dificulltyButton(Duration duration, String name, String durationString) {
    return Expanded(child: ElevatedButton(
        onPressed: () => setState(() {
          controller.cardsToStudy[controller.indexCardShowing].timeToStudy = DateTime.now().add(duration);
          FileManager.instance.saveCards();
          controller.cardsStudied.add(controller.indexCardShowing);
          controller.nextCard();
        }), 
        child: ListTile(
          title: Text(name,textAlign: TextAlign.center, maxLines: 1,),
          subtitle: Text(durationString),
        )
        ));
  }

  Widget _showImageInDialog(File? file, CardModel card, String text){
    
    if(file != null) {
      return Column(
        children: [
          Expanded(flex:1,child: Text(text)),
          Expanded(flex:8,child: Image.file(file)),
        ],
      );
    } else {
      return Text(text);
    }

  }



}
