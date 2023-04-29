import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/components/add_card_related/tool_bar.dart';

import '../../controllers/add_card_controller.dart';

class CardFront extends StatelessWidget {
  void Function(bool) allowShowingImage;
  void Function(double, PainterController) changeStroke;
  void Function(PainterController) alternateEraser;
  AddCardController controller;
  CardFront({
    super.key,
    required this.controller,
    required this.allowShowingImage,
    required this.alternateEraser,
    required this.changeStroke,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: controller.highlightFrontText
                    ? const BorderSide(color: Colors.red)
                    : const BorderSide(
                        color: Color.fromARGB(255, 146, 146, 146)),
              ),
              border: OutlineInputBorder(
                borderSide: controller.highlightFrontText
                    ? const BorderSide(color: Colors.red)
                    : const BorderSide(
                        color: Color.fromARGB(255, 146, 146, 146)),
              ),
            ),
            controller: controller.frontTextController,
            maxLines: null,
          ),
          Visibility(
            visible: !controller.showImageFront,
            child: CheckboxListTile(
                title: const Text("Draw"),
                value: controller.showImageFront,
                onChanged: (value) => allowShowingImage(value!)),
          ),
          Visibility(
            visible: controller.showImageFront,
            child: ToolBar(
              controller: controller,
              painterController: controller.frontPainterController,
              allowShowingImage: allowShowingImage,
              alternateEraser: alternateEraser,
              changeStroke: changeStroke,
            ),
          ),
          const Divider(),
          Visibility(
            visible: controller.showImageFront,
            child: Expanded(
                child: FlutterPainter.builder(
                    controller: controller.frontPainterController,
                    builder: (context, painter) {
                      return SizedBox(child: painter);
                    })),
          ),
        ],
      ),
    );
  }
}
