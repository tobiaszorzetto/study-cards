import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_cards/components/study_cards_related/dificulty_button.dart';
import 'package:study_cards/components/study_cards_related/front_card.dart';
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
  State<StudyCardsPage> createState() =>
      _StudyCardsPageState(folder, cardsToStudy);
}

class _StudyCardsPageState extends State<StudyCardsPage> {
  late StudyCardsController controller;

  _StudyCardsPageState(folder, cardsToStudy) {
    controller = StudyCardsController(folder, cardsToStudy);
  }

  void updateCard(Duration duration) {
    setState(() {
      controller.updateCard(duration);
    });
  }

  void changeCardSide() {
    setState(() {
      controller.showAnswer = !controller.showAnswer;
    });
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
                builder: (context) => FolderPage(folder: controller.folder)));
          }),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () => setState(() {
                      controller.lastCard();
                    }),
                icon: const Icon(Icons.arrow_back_ios_new)),
            controller.cardsToStudy.length != controller.cardsStudied.length
                ? _showCard()
                : const Text("No more cards to study"),
            IconButton(
                onPressed: () => setState(() {
                      controller.nextCard();
                    }),
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }

  Widget _showCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [controller.showAnswer ? _showBack() : FrontCard(controller: controller,changeCardSide: changeCardSide,)],
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
                    onPressed: () => changeCardSide(),
                    child: const Icon(Icons.arrow_upward)),
              ),
              Expanded(
                  flex: 10,
                  child: _showImageInDialog(
                      controller.backCardFile,
                      controller.cardsToStudy[controller.indexCardShowing],
                      controller.cardsToStudy[controller.indexCardShowing]
                          .backDescription)),
              Expanded(flex: 2, child: _showDificultyOptions())
            ],
          ),
        ),
      ),
    );
  }


  Row _showDificultyOptions() {
    return Row(
      children: [
        DificultyButton(
          duration: const Duration(minutes: 0),
          name: "Try again",
          durationString: "0 min",
          updateCard: updateCard,
        ),
        DificultyButton(
            duration: const Duration(minutes: 10),
            name: "Hard",
            durationString: "10 min",
            updateCard: updateCard),
        DificultyButton(
            duration: const Duration(days: 1),
            name: "Medium",
            durationString: "1 day",
            updateCard: updateCard),
        DificultyButton(
          duration: const Duration(days: 6),
          name: "Easy",
          durationString: "6 days",
          updateCard: updateCard,
        ),
      ],
    );
  }

  Widget _showImageInDialog(File? file, CardModel card, String text) {
    if (file != null) {
      return Column(
        children: [
          Expanded(flex: 1, child: Text(text)),
          Expanded(flex: 8, child: Image.file(file)),
        ],
      );
    } else {
      return Text(text);
    }
  }
}
