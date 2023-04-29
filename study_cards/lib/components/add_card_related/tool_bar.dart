import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:scribble/scribble.dart';

import '../../controllers/add_card_controller.dart';

class ToolBar extends StatelessWidget {
  AddCardController controller;
  PainterController painterController;
  void Function(bool) allowShowingImage;
  void Function(PainterController) alternateEraser;
  void Function(double, PainterController) changeStroke;

  ToolBar({
    super.key,
    required this.controller,
    required this.painterController,
    required this.allowShowingImage,
    required this.alternateEraser,
    required this.changeStroke,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildEraserButton(),
                _buildColorButton(context, color: Colors.black),
                _buildColorButton(context, color: Colors.red),
                _buildColorButton(context, color: Colors.blue),
                _buildShapeButton(context),
                _buildTextButton(context),
                _buildSelectButton(context),
              ],
            ),
          ),
          Expanded(child: _buildStrokeSlider(context)),
          //_buildRecordButton(),
        ],
      ),
      trailing: Checkbox(
        value: controller.showFrontSide
            ? controller.showImageFront
            : controller.showImageBack,
        onChanged: (value) => allowShowingImage(value!),
      ),
    );
  }

  Widget _buildEraserButton() {
    controller.drawingColor = Colors.white;
    return Padding(
        padding: const EdgeInsets.all(4),
        child: FloatingActionButton.small(
          tooltip: "Erase",
          backgroundColor: const Color(0xFFF7FBFF),
          elevation: controller.eraseSelected ? 10 : 2,
          shape: !controller.eraseSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
          child: const Icon(Icons.remove, color: Colors.blueGrey),
          onPressed: () => alternateEraser(painterController),
        ));
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
  }) {
    controller.drawingColor = color;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          heroTag: "btn${color.toString()}",
          backgroundColor: color,
          child: Container(),
          onPressed: () {
            painterController.freeStyleColor = color;
            painterController.freeStyleMode = FreeStyleMode.draw;
          } ),
    );
  }

  Widget _buildShapeButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
          icon: const Icon(Icons.rectangle),
          onPressed: () => painterController.shapeFactory = RectangleFactory()),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
          icon: const Icon(Icons.text_fields),
          onPressed: () {
            if (painterController.freeStyleMode != FreeStyleMode.none) {
              painterController.freeStyleMode = FreeStyleMode.none;
            }
            painterController.addText();
          }),
    );
  }
  Widget _buildSelectButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
          icon: painterController.freeStyleMode == FreeStyleMode.draw? const Icon(Icons.mouse) : const Icon(Icons.draw),
          onPressed: () {
            if (painterController.freeStyleMode == FreeStyleMode.none) {
              painterController.freeStyleMode = FreeStyleMode.draw;
            } else{
              painterController.freeStyleMode = FreeStyleMode.none;
            }
          }),
    );
  }

  Widget _buildStrokeSlider(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Slider(
        min: 1,
        max: 20,
        activeColor: controller.drawingColor,
        inactiveColor: controller.drawingColor,
        thumbColor: controller.drawingColor,
        divisions: 19,
        label: controller.stroke.toString(),
        value: controller.stroke,
        onChanged: (value) => changeStroke(value, painterController),
      ),
    );
  }
}
