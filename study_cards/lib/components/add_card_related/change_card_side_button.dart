import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/add_card_controller.dart';

class ChangeCardSideButton extends StatelessWidget {
  AddCardController controller;
  ChangeCardSideButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          controller.changeCardSide();
        },
        icon: const Icon(Icons.change_circle_outlined),
        label: controller.animationStatus == AnimationStatus.dismissed
            ? const Text("front")
            : const Text("back"));
  }
}