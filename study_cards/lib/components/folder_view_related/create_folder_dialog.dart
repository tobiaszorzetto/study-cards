import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/controllers/folder_controller.dart';

class CreateFolderDialog extends StatelessWidget {
  FolderController controller;
  Function(BuildContext) onCreateFolder;
  CreateFolderDialog(
      {super.key, required this.controller, required this.onCreateFolder});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Folders"),
      content: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 4,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() {
                    controller.folderCreateNameController.text = value;
                    controller.validateFolder();
                  }),
                ),
              ),
              Expanded(
                child: controller.folderCreateValidated
                    ? const SizedBox()
                    : const Text(
                        "A folder with this name already exists",
                        style: TextStyle(color: Colors.red),
                      ),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => onCreateFolder(context),
          child: const Text("Add"),
        )
      ],
    );
  }
}
