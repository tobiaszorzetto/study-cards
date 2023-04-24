import 'package:flutter/material.dart';

import 'dificulty_button.dart';

class DificultyList extends StatelessWidget {
  void Function(Duration duration) updateCard;

  DificultyList({
    super.key,
    required this.updateCard,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DificultyButton(
          duration: const Duration(minutes: 0),
          name: "Try again",
          durationString: "0 min",
          updateCard: updateCard,
        ),
        DificultyButton(
            duration: const Duration(minutes: 10),
            name: "Hard",
            durationString: "10 min",
            updateCard: updateCard),
        DificultyButton(
            duration: const Duration(days: 1),
            name: "Medium",
            durationString: "1 day",
            updateCard: updateCard),
        DificultyButton(
          duration: const Duration(days: 6),
          name: "Easy",
          durationString: "6 days",
          updateCard: updateCard,
        ),
      ],
    );
  }
}
