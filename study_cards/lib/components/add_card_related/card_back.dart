import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/components/add_card_related/tool_bar.dart';
import 'dart:math' as math;
import '../../controllers/add_card_controller.dart';

class CardBack extends StatelessWidget {
  void Function(bool) allowShowingImage;
  void Function(double, PainterController) changeStroke;
  void Function(PainterController) alternateEraser;
  AddCardController controller;
  CardBack({
    super.key,
    required this.controller,
    required this.allowShowingImage,
    required this.alternateEraser,
    required this.changeStroke,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: Card(
        child: Column(
          children: [
            TextField(
              controller: controller.backTextController,
              maxLines: null,
            ),
            Visibility(
              visible: !controller.showImageBack,
              child: CheckboxListTile(
                  title: const Text("Draw"),
                  value: controller.showImageBack,
                  onChanged: (value) => allowShowingImage(value!)),
            ),
            Visibility(
              visible: controller.showImageBack,
              child: ToolBar(
                controller: controller,
                painterController: controller.backPainterController,
                allowShowingImage: allowShowingImage,
                alternateEraser: alternateEraser,
                changeStroke: changeStroke,
              ),
            ),
            const Divider(),
            Visibility(
              visible: controller.showImageBack,
              child: Expanded(
                child: FlutterPainter.builder(
                    controller: controller.backPainterController,
                    builder: (context, painter) {
                      return SizedBox(child: painter);
                    })
              ),
            ),
          ],
        ),
      ),
    );
  }
}
