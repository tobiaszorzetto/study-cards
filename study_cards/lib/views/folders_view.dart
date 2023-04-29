import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/components/folder_view_related/card_dialog.dart';
import 'package:study_cards/components/folder_view_related/create_folder_dialog.dart';
import 'package:study_cards/components/folder_view_related/delete_folder_dialog.dart';

import 'package:study_cards/components/folder_view_related/subfolders.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/add_card_page.dart';
import '../components/folder_view_related/cards.dart';
import '../components/folder_view_related/cards_to_study.dart';
import '../models/card_model.dart';

class FolderPage extends StatefulWidget {
  FolderModel folder;
  User user;

  FolderPage({required this.folder, super.key, required this.user});

  @override
  State<FolderPage> createState() => _FolderPageState(folder, user);
}

class _FolderPageState extends State<FolderPage> {
  late FolderController folderController;

  User user;

  _FolderPageState(folder, this.user) {
    folderController = FolderController(folder, user);
  }

  addFolder() {
    setState(() {
      folderController.folderCreateValidated = true;
      _createFolderDialog();
    });
  }

  deleteFolder(int folderIndex) {
    setState(() {
      folderController.deleteSubfolder(folderIndex);
    });
  }

  gotoFolder(FolderModel folder) {
    setState(() {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FolderPage(folder: folder, user: user),
      ));
    });
  }

  gotoAddCardPage() {
    setState(() {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddCardPage(folder: folderController.folder, user: user,),
        ),
      );
    });
  }

  void onCreateFolder(BuildContext context){
    setState(() {
      if (!folderController.validateFolder() ||
          folderController.folderCreateNameController.text
                  .replaceAll(" ", "") ==
              "") return;
      folderController.createFolder();
      Navigator.of(context).pop();
    });
  }

  void onDeleteFolder(int folderIndex, BuildContext context) {
    setState(() {  
      Navigator.of(context).pop();
      folderController.deleteSubfolder(folderIndex);
    });
  }

  void onDeleteCard(int cardIndex, BuildContext context) {
    setState(() {  
      Navigator.of(context).pop();
      folderController.deleteCard(cardIndex);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 169, 186),
        title: Text(folderController.folder.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            if (folderController.folder.parentFolder != null) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    FolderPage(folder: folderController.folder.parentFolder!, user: user,),
              ));
            }
          }),
        ),
        actions: [
          IconButton(
            onPressed: () {
              
            }, 
            icon: Icon(Icons.settings))
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            CardsToStudy(folderController: folderController, user: user,),
            const Divider(),
            //const SizedBox(height: 50,),
            SubFolders(
                controller: folderController,
                gotoFolder: gotoFolder,
                addFolder: addFolder,
                showDeleteFolderDialog: _showDeleteFolderDialog),
            const Divider(),
            Cards(
                gotoAddCardPage: gotoAddCardPage,
                controller: folderController,
                showDeleteCardDialog: _showDeleteCardDialog,
                showCardDialog: _showCardDialog),
          ],
        ),
      ),
    );
  }

  _createFolderDialog() {
    return showDialog(
        context: context,
        builder: (context) => CreateFolderDialog(controller: folderController, onCreateFolder: onCreateFolder)
        );
  }

  Future<void> _showCardDialog(BuildContext context, CardModel card) async {
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (context) => CardDialog(controller: folderController, card: card, updateCardsToStudy: _updateCardsToStudy),
    );
  }

  void _updateCardsToStudy(CardModel card) {
    setState(() {
      folderController.createTimeToStudy(card);
    });
  }
  
  _showDeleteCardDialog(int cardIndex) {
    showDialog(
        context: context,
        builder: (context) => DeleteObjectDialog(index: cardIndex, folderController: folderController, onDeleteObject: onDeleteCard, objName: "card",)
      );
  }

  _showDeleteFolderDialog(int folderIndex) {
    showDialog(
        context: context,
        builder: (context) => DeleteObjectDialog(index: folderIndex, folderController: folderController, onDeleteObject: onDeleteFolder, objName: "folder",)
      );
  }
}
