import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../controllers/add_card_controller.dart';
import '../../views/folders_view.dart';

class AddCardButton extends StatelessWidget {
  AddCardController controller;
  void Function() addCard;
  AddCardButton({super.key, required this.controller, required this.addCard});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => addCard(),
      child: const Text("Add"),
    );
  }
}
