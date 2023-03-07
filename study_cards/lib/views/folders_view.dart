import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_cards/components/add_card_related/add_card_button.dart';
import 'package:study_cards/components/folder_view_related/add_card_button.dart';
import 'package:study_cards/components/folder_view_related/subfolders.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/add_card_page.dart';
import 'package:study_cards/views/study_cards_page.dart';

import '../components/folder_view_related/cards.dart';
import '../components/folder_view_related/cards.dart';
import '../components/folder_view_related/cards_to_study.dart';
import '../models/card_model.dart';

class FolderPage extends StatefulWidget {
  FolderModel folder;

  FolderPage({required this.folder, super.key});

  @override
  State<FolderPage> createState() => _FolderPageState(folder);
}

class _FolderPageState extends State<FolderPage> {
  late FolderController folderController;

  _FolderPageState(folder) {
    folderController = FolderController(folder);
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
        builder: (context) => FolderPage(folder: folder),
      ));
    });
  }

  gotoAddCardPage() {
    setState(() {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddCardPage(folder: folderController.folder),
        ),
      );
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
                    FolderPage(folder: folderController.folder.parentFolder!),
              ));
            }
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => setState(() {
              FileManager.instance.saveCards();
            }),
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            CardsToStudy(folderController: folderController),
            const Divider(),
            //const SizedBox(height: 50,),
            SubFolders(controller: folderController, gotoFolder: gotoFolder, addFolder: addFolder, showDeleteFolderDialog: _showDeleteFolderDialog),
            const Divider(),
            Cards(gotoAddCardPage: gotoAddCardPage, controller: folderController, showDeleteCardDialog: _showDeleteCardDialog, showCardDialog: _showCardDialog),
          ],
        ),
      ),
    );
  }



  _createFolderDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                            folderController.folderCreateNameController.text =
                                value;
                            folderController.validateFolder();
                          }),
                        ),
                      ),
                      Expanded(
                        child: folderController.folderCreateValidated
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
                  onPressed: () => setState(() {
                    if (!folderController.validateFolder() ||
                        folderController.folderCreateNameController.text
                                .replaceAll(" ", "") ==
                            "") return;
                    folderController.createFolder();

                    Navigator.of(context).pop();
                  }),
                  child: const Text("Add"),
                )
              ],
            ));
  }

 
  Future<void> _showCardDialog(BuildContext context, CardModel card) async {
    await folderController.prepareImages(card);

    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (context) => SizedBox(
              child: AlertDialog(
                content: StatefulBuilder(
                  builder: (context, setState) => SizedBox(
                    height: 600,
                    width: 600,
                    child: SingleChildScrollView(
                      controller: folderController.scrollController,
                      child: Column(
                        children: [
                          Text(card.frontDescription),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: _showCardInDialog(
                                folderController.frontCardExists,
                                folderController.frontCardFile,
                                card,
                                card.frontDescription),
                          ),
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    folderController.showBack =
                                        !folderController.showBack;
                                    if (folderController.showBack) {
                                      folderController.scrollController
                                          .animateTo(600,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease);
                                    } else {
                                      folderController.scrollController
                                          .animateTo(0,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease);
                                    }
                                  }),
                              child: const Text("Show Back")),
                          Visibility(
                            visible: folderController.showBack,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              child: _showCardInDialog(
                                  folderController.backCardExists,
                                  folderController.backCardFile,
                                  card,
                                  card.backDescription),
                            ),
                          ),
                          Visibility(
                            visible: folderController.showBack,
                            child: Row(
                              children: [
                                Slider(
                                    min: 0,
                                    max: 3,
                                    value: folderController.cardDificulty
                                        .toDouble(),
                                    onChanged: (value) => setState(
                                          () {
                                            folderController.cardDificulty =
                                                value.toInt();
                                            folderController.setTimeToStudy();
                                          },
                                        )),
                                Text(folderController.showDificultyLabel()),
                                Text(folderController.timeToStudy.toString()),
                                ElevatedButton(
                                    onPressed: () => setState(() {
                                          _updateCardsToStudy(card);
                                        }),
                                    child: const Text("OK"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void _updateCardsToStudy(CardModel card) {
    setState(() {
      folderController.createTimeToStudy(card);
    });
  }



  Widget _showCardInDialog(
      bool fileExists, File file, CardModel card, String text) {
    if (fileExists) {
      return Column(
        children: [
          Text(text),
          Expanded(child: Image.file(file)),
        ],
      );
    }
    return Text(text);
  }

  _showDeleteCardDialog(int cardIndex) {
    showDialog(
        context: context,
        builder: (context) => SizedBox(
              child: AlertDialog(
                content: StatefulBuilder(
                    builder: (context, setState) =>
                        const Text("Do you want to delete this card?")),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            Navigator.of(context).pop();
                            folderController.deleteCard(cardIndex);
                          }),
                      child: const Text("OK")),
                ],
              ),
            ));
  }

  _showDeleteFolderDialog(int folderIndex) {
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
