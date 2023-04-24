import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:study_cards/controllers/study_cards_controller.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/views/folders_view.dart';
import '../components/study_cards_related/study_card.dart';
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
                ? StudyCard(
                    changeCardSide: changeCardSide,
                    controller: controller,
                    updateCard: updateCard,
                  )
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
}
