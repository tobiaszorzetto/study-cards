import 'package:flutter/material.dart';
import 'package:study_cards/components/study_cards_related/back_card.dart';

import '../../controllers/study_cards_controller.dart';
import 'front_card.dart';

class StudyCard extends StatelessWidget {
  final StudyCardsController controller;
  void Function(Duration duration) updateCard;
  void Function() changeCardSide;
  StudyCard({
    super.key,
    required this.controller,
    required this.changeCardSide,
    required this.updateCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.showAnswer
                  ? BackCard(
                      changeCardSide: changeCardSide,
                      controller: controller,
                      updateCard: updateCard,
                    )
                  : FrontCard(
                      controller: controller,
                      changeCardSide: changeCardSide,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
