import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/models/card_model.dart';

class CardDialog extends StatelessWidget {
  final CardModel card;
  final FolderController controller;
  Function(CardModel) updateCardsToStudy;
  CardDialog(
      {super.key,
      required this.controller,
      required this.card,
      required this.updateCardsToStudy});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: AlertDialog(
            content: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                      height: 600,
                      width: 600,
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          children: [
                            Text(card.frontDescription),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              child: _showCardInDialog(
                                  controller.frontCardExists,
                                  controller.frontCardFile,
                                  card,
                                  card.frontDescription),
                            ),
                            ElevatedButton(
                                onPressed: () => setState(() {
                                      controller.showBack =
                                          !controller.showBack;
                                      if (controller.showBack) {
                                        controller.scrollController.animateTo(
                                            600,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease);
                                      } else {
                                        controller.scrollController.animateTo(0,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease);
                                      }
                                    }),
                                child: const Text("Show Back")),
                            Visibility(
                              visible: controller.showBack,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 2,
                                child: _showCardInDialog(
                                    controller.backCardExists,
                                    controller.backCardFile,
                                    card,
                                    card.backDescription),
                              ),
                            ),
                            Visibility(
                              visible: controller.showBack,
                              child: Row(
                                children: [
                                  Slider(
                                      min: 0,
                                      max: 3,
                                      value:
                                          controller.cardDificulty.toDouble(),
                                      onChanged: (value) => setState(
                                            () {
                                              controller.cardDificulty =
                                                  value.toInt();
                                              controller.setTimeToStudy();
                                            },
                                          )),
                                  Text(controller.showDificultyLabel()),
                                  Text(controller.timeToStudy.toString()),
                                  ElevatedButton(
                                      onPressed: () => setState(() {
                                            updateCardsToStudy(card);
                                          }),
                                      child: const Text("OK"))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))));
  }

  Widget _showCardInDialog(
      bool fileExists, File file, CardModel card, String text) {
    if (fileExists) {
      return Column(
        children: [
          Text(text),
          Expanded(child: Image.file(file)),
        ],
      );
    }
    return Text(text);
  }
}
