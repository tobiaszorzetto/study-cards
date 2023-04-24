import 'package:flutter/material.dart';

import '../../controllers/study_cards_controller.dart';
import 'dialog_image.dart';
import 'dificulty_list.dart';

class BackCard extends StatelessWidget {
  void Function() changeCardSide;
  void Function(Duration duration) updateCard;
  StudyCardsController controller;

  BackCard({
    super.key,
    required this.controller,
    required this.changeCardSide,
    required this.updateCard,
  });

  @override
  Widget build(BuildContext context) {
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
                child: DialogImage(
                    file: controller.cardsToStudy[controller.indexCardShowing].backCardData,
                    text: controller.cardsToStudy[controller.indexCardShowing]
                        .backDescription),
              ),
              Expanded(flex: 2, child: DificultyList(updateCard: updateCard))
            ],
          ),
        ),
      ),
    );
  }
}
