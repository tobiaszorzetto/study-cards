import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';

import '../../controllers/add_card_controller.dart';

class ToolBar extends StatelessWidget {
  AddCardController controller;
  ScribbleNotifier notifier;
  void Function(bool) allowShowingImage;
  void Function(ScribbleNotifier) alternateEraser;
  void Function(double, ScribbleNotifier) changeStroke;

  ToolBar(
      {super.key,
      required this.controller,
      required this.notifier,
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
                _buildEraserButton(notifier),
                _buildColorButton(context,
                    color: Colors.black, notifier: notifier),
                _buildColorButton(context,
                    color: Colors.red, notifier: notifier),
                _buildColorButton(context,
                    color: Colors.blue, notifier: notifier),
              ],
            ),
          ),
          Expanded(child: _buildStrokeSlider(context, notifier: notifier)),
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

  Widget _buildEraserButton(ScribbleNotifier notifier) {
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
        onPressed: () => alternateEraser(notifier),
      )
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleNotifier notifier,
  }) {
    controller.drawingColor = color;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          heroTag: "btn${color.toString()}",
          backgroundColor: color,
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildStrokeSlider(
    BuildContext context, {
    required ScribbleNotifier notifier,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Slider(
          min: 1,
          max: 10,
          activeColor: controller.drawingColor,
          inactiveColor: controller.drawingColor,
          thumbColor: controller.drawingColor,
          divisions: 9,
          label: controller.stroke.toString(),
          value: controller.stroke,
          onChanged: (value) => changeStroke(value,notifier),
        ),
    );
  }
}
