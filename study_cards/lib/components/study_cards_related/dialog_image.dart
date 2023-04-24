import 'dart:typed_data';
import 'package:flutter/material.dart';

class DialogImage extends StatelessWidget {
  final Uint8List? file;
  final String text;
  const DialogImage({super.key, required this.text, required this.file});

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Column(
        children: [
          Expanded(flex: 1, child: Text(text)),
          Expanded(flex: 8, child: Image.memory(file!)),
        ],
      );
    } else {
      return Text(text);
    }
  }
}
