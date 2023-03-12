import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import '../../controllers/add_card_controller.dart';
import 'card_back.dart';
import 'card_front.dart';

class ShowCard extends StatelessWidget {
  AddCardController controller;
  void Function(bool) allowShowingImage;
  void Function(double, ScribbleNotifier) changeStroke;
  void Function(ScribbleNotifier) alternateEraser;
  ShowCard(
      {super.key,
      required this.controller,
      required this.allowShowingImage,
      required this.changeStroke,
      required this.alternateEraser});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: FlipCard(
        controller: controller.flipCardController,
        flipOnTouch: false,
        front: CardFront(
                    controller: controller,
                    allowShowingImage: allowShowingImage,
                    alternateEraser: alternateEraser,
                    changeStroke: changeStroke,
                  ),
        back: CardBack(
                    controller: controller,
                    allowShowingImage: allowShowingImage,
                    alternateEraser: alternateEraser,
                    changeStroke: changeStroke,
                  ),
      ),
    );
  }
}
