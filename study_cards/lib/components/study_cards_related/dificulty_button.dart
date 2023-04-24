import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DificultyButton extends StatelessWidget {
  final String name;
  final String durationString;
  final Duration duration;
  Function (Duration) updateCard;
  DificultyButton({super.key, required this.name, required this.duration, required this.durationString, required this.updateCard});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ElevatedButton(
            onPressed: () => updateCard(duration),
            child: ListTile(
              title: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              subtitle: Text(durationString),
            )));
  }
}