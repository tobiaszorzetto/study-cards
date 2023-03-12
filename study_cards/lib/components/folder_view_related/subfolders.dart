import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:study_cards/components/folder_view_related/add_folder_button.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/models/folder_model.dart';

import '../../views/folders_view.dart';

class SubFolders extends StatelessWidget {
  FolderController controller;
  Function() addFolder;
  Function(FolderModel) gotoFolder;
  Function(int) showDeleteFolderDialog;
  SubFolders(
      {super.key,
      required this.controller,
      required this.gotoFolder,
      required this.addFolder,
      required this.showDeleteFolderDialog});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ListTile(
                tileColor: const Color.fromARGB(255, 129, 169, 186),
                leading: const Icon(Icons.folder),
                title: Text(
                  "Folders",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: AddFolderButton(addFolder: addFolder),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: controller.folder.subFolders.length,
                  itemBuilder: (buildContext, index) {
                    return ListTile(
                      title: Text(controller.folder.subFolders[index].name),
                      onTap: () =>
                          gotoFolder(controller.folder.subFolders[index]),
                      trailing: IconButton(
                          onPressed: () => showDeleteFolderDialog(index),
                          icon: const Icon(Icons.delete)),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
