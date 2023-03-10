import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/controllers/folder_controller.dart';

class DeleteObjectDialog extends StatelessWidget {
  final int index;
  final FolderController folderController;
  final String objName;
  void Function(int, BuildContext) onDeleteObject;

  DeleteObjectDialog({
    super.key,
    required this.index,
    required this.folderController,
    required this.onDeleteObject,
    required this.objName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        content: StatefulBuilder(
            builder: (context, setState) =>
                Text("Do you want to delete this $objName?")),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => onDeleteObject(index, context),
              child: const Text("OK")),
        ],
      ),
    );
  }
}
