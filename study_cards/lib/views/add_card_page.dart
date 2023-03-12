import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/controllers/add_card_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/folders_view.dart';

import '../components/add_card_related/add_card_button.dart';
import '../components/add_card_related/change_card_side_button.dart';
import '../components/add_card_related/show_card.dart';

class AddCardPage extends StatefulWidget {
  FolderModel folder;
  AddCardPage({super.key, required this.folder});

  @override
  State<AddCardPage> createState() => _AddCardPageState(folder);
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  late AddCardController controller;
  _AddCardPageState(folder) {
    controller = AddCardController(folder);
  }

  @override
  void initState() {
    controller.notifierFront = ScribbleNotifier();
    controller.notifierBack = ScribbleNotifier();
    controller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.animation =
        Tween(end: 1.0, begin: 0.0).animate(controller.animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            controller.animationStatus = status;
          });
    super.initState();
    //_initRecorder();
  }

  void _allowShowingImage(bool value) {
    setState(() {
      controller.showFrontSide
          ? controller.showImageFront = value
          : controller.showImageBack = value;
    });
  }

  void _alternateEraser(ScribbleNotifier notifier) {
    setState(() {
      if (controller.eraseSelected) {
        controller.eraseSelected = false;
        notifier.setColor(Colors.black);
      } else {
        controller.eraseSelected = true;
        notifier.setEraser();
      }
    });
  }

  void _changeStroke(double value, ScribbleNotifier notifier) {
    setState(() {
      controller.stroke = value;
      notifier.setStrokeWidth(controller.stroke);
    });
  }

  void _addCard() {
    setState(() {
      if (controller.frontTextController.text.replaceAll(" ", "") != "" && controller.validateCard()) {
        controller.addCard();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FolderPage(folder: controller.folder),
          ),
        );
      } else {
        controller.highlightFrontText = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Card"),
        leading: IconButton(
            onPressed: () => setState(() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FolderPage(folder: controller.folder),
                    ),
                  );
                }),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ChangeCardSideButton(controller: controller),
              ShowCard(
                  controller: controller,
                  allowShowingImage: _allowShowingImage,
                  changeStroke: _changeStroke,
                  alternateEraser: _alternateEraser),
              AddCardButton(controller: controller, addCard: _addCard),
            ],
          ),
        ],
      ),
    );
  }
}
