import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/controllers/add_card_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/folders_view.dart';

import '../components/add_card_related/add_card_button.dart';
import '../components/add_card_related/change_card_side_button.dart';
import '../components/add_card_related/show_card.dart';

class AddCardPage extends StatefulWidget {
  FolderModel folder;
  User user;
  AddCardPage({super.key, required this.folder, required this.user});

  @override
  State<AddCardPage> createState() => _AddCardPageState(folder, user);
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  late AddCardController controller;
  User user;
  _AddCardPageState(folder, this.user) {
    controller = AddCardController(folder, user);
  }

  @override
  void initState() {
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

  void _alternateEraser(PainterController painterController) {
    setState(() {
      if (controller.eraseSelected) {
        controller.eraseSelected = false;
        painterController.freeStyleMode = FreeStyleMode.draw;
      } else {
        controller.eraseSelected = true;
        painterController.freeStyleMode = FreeStyleMode.erase;
      }
    });
  }

  void _changeStroke(double value, PainterController painterController) {
    setState(() {
      controller.stroke = value;
      painterController.freeStyleStrokeWidth = controller.stroke;
    });
  }

  Future<void> _addCard() async{
    setState(() async {
      if (controller.frontTextController.text.replaceAll(" ", "") != "") {
        await controller.addCard(context);
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FolderPage(folder: controller.folder, user: user,),
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
                          FolderPage(folder: controller.folder, user: user,),
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
