import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/add_card_controller.dart';

class ChangeCardSideButton extends StatelessWidget {
  AddCardController controller;
  Function() changeSide;
  ChangeCardSideButton({super.key, required this.controller, required this.changeSide});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => changeSide(),
        icon: const Icon(Icons.change_circle_outlined),
        label: controller.showFrontSide
            ? const Text("front")
            : const Text("back"));
  }
}
