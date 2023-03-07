import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class GotoAddCardButton extends StatelessWidget {
  Function() gotoAddCardPage;
  GotoAddCardButton({super.key, required this.gotoAddCardPage});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => gotoAddCardPage,
      child: const Icon(Icons.add),
    );
  }
}
