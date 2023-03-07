import 'package:flutter/material.dart';

class AddFolderButton extends StatelessWidget {
  Function() addFolder;
  AddFolderButton({super.key, required this.addFolder});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => addFolder(),
      child: const Icon(Icons.add),
    );
  }
}
