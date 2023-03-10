import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/controllers/study_cards_controller.dart';

import '../../models/card_model.dart';

class FrontCard extends StatelessWidget {
  Function changeCardSide;
  StudyCardsController controller;
  FrontCard({super.key, required this.controller, required this.changeCardSide});

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
                  child: _showImageInDialog(
                      controller.frontCardFile,
                      controller.cardsToStudy[controller.indexCardShowing],
                      controller.cardsToStudy[controller.indexCardShowing]
                          .frontDescription)),
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