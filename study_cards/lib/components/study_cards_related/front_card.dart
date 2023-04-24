import 'package:flutter/material.dart';
import 'package:study_cards/controllers/study_cards_controller.dart';
import 'dialog_image.dart';

class FrontCard extends StatelessWidget {
  void Function() changeCardSide;
  StudyCardsController controller;
  FrontCard(
      {super.key, required this.controller, required this.changeCardSide});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !controller.showAnswer,
      child: Expanded(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 16,
                child: DialogImage(
                    file: controller.cardsToStudy[controller.indexCardShowing].frontCardData,
                    text: controller.cardsToStudy[controller.indexCardShowing]
                        .frontDescription),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () => changeCardSide(),
                    child: const Icon(Icons.arrow_downward)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
