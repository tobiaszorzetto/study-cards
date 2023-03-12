import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/add_card_controller.dart';

class ChangeCardSideButton extends StatefulWidget {
  AddCardController controller;
  ChangeCardSideButton({super.key, required this.controller});

  @override
  State<ChangeCardSideButton> createState() => _ChangeCardSideButtonState();
}

class _ChangeCardSideButtonState extends State<ChangeCardSideButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => setState(() {
          widget.controller.changeCardSide();
        }),
        icon: const Icon(Icons.change_circle_outlined),
        label: widget.controller.showFrontSide
            ? const Text("front")
            : const Text("back"));
  }
}
