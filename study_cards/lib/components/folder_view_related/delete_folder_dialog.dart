import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/controllers/folder_controller.dart';

class DeleteFolderDialog extends StatelessWidget {
  final int folderIndex;
  final FolderController folderController;
  void Function(int, FolderController) onDeleteFolder;

  DeleteFolderDialog({
    super.key,
    required this.folderIndex,
    required this.folderController,
    required this.onDeleteFolder,
  });

  @override
  Widget build(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SizedBox(
              child: AlertDialog(
                content: StatefulBuilder(
                    builder: (context, setState) =>
                        const Text("Do you want to delete this folder?")),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () => ,
                      child: const Text("OK")),
                ],
              ),
            ));
  }
}
