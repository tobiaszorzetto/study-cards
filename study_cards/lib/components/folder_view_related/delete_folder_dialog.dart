import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DeleteFolderDialog extends StatelessWidget {
  const DeleteFolderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    showDialog(
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
                      onPressed: () => setState(() {
                            Navigator.of(context).pop();
                            folderController.deleteSubfolder(folderIndex);
                          }),
                      child: const Text("OK")),
                ],
              ),
            ));
  }
}
