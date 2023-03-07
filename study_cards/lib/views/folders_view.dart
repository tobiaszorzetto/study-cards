import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/add_card_page.dart';
import 'package:study_cards/views/study_cards_page.dart';

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

  @override
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
            Expanded(flex: 2, child: _CardsToStudy()),
            const Divider(),
            //const SizedBox(height: 50,),
            Expanded(flex: 3, child: _showFolders(context)),
            const Divider(),
            Expanded(flex: 3, child: _showCards(context)),
          ],
        ),
      ),
    );
  }

  Widget _CardsToStudy() {
    folderController.setCardsToStudy();
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Text(
                        "${folderController.cardsToStudy.length}",
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          height:
                              0, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                          color: folderController.cardsToStudy.isNotEmpty
                              ? Colors.redAccent
                              : Colors.green, //font color
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "cards pending studying",
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () => folderController.cardsToStudy.isNotEmpty
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StudyCardsPage(
                        folder: folderController.folder,
                        cardsToStudy: folderController.cardsToStudy),
                  ))
                : {},
            child: const Text("Study Cards"),
          ),
        )
      ],
    );
  }

  _addCard() {
    return ElevatedButton(
      onPressed: () => setState(() {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddCardPage(folder: folderController.folder),
          ),
        );
      }),
      child: const Icon(Icons.add),
    );
  }

  _addFolderButton() {
    return ElevatedButton(
      onPressed: () => setState(() {
        folderController.folderCreateValidated = true;
        _createFolderDialog();
      }),
      child: const Icon(Icons.add),
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
                    if (!folderController.validateFolder() || folderController.folderCreateNameController.text.replaceAll(" ", "") == "" ) return;
                    folderController.createFolder();
                    Navigator.of(context).pop();
                  }),
                  child: const Text("Add"),
                )
              ],
            ));
  }

  _showFolders(BuildContext context) {
    return Card(
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
              trailing: _addFolderButton(),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: folderController.folder.subFolders.length,
                itemBuilder: (buildContext, index) {
                  return ListTile(
                    title: Text(folderController.folder.subFolders[index].name),
                    onTap: () => setState(() {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FolderPage(
                            folder: folderController.folder.subFolders[index]),
                      ));
                    }),
                    trailing: IconButton(
                        onPressed: () => _showDeleteFolderDialog(index),
                        icon: const Icon(Icons.delete)),
                  );
                }),
          ),
        ],
      ),
    );
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
                                    label: showDificultyLabel(),
                                    value: folderController.cardDificulty
                                        .toDouble(),
                                    onChanged: (value) => setState(
                                          () {
                                            folderController.cardDificulty =
                                                value.toInt();
                                            folderController.setTimeToStudy();
                                          },
                                        )),
                                Text(showDificultyLabel()),
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

  String showDificultyLabel() {
    if (folderController.cardDificulty == 0) {
      return "Easy";
    } else if (folderController.cardDificulty == 1) {
      return "Medium";
    } else if (folderController.cardDificulty == 2) {
      return "Hard";
    }
    return "Try Again";
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

  _showCards(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListTile(
              tileColor: Color.fromARGB(255, 129, 169, 186),
              leading: const Icon(Icons.note),
              title: Text(
                "Cards",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: _addCard(),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: folderController.folder.cards.length,
                itemBuilder: (buildContext, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.circle,
                      color: folderController.cardsToStudy
                              .contains(folderController.folder.cards[index])
                          ? Colors.red
                          : Colors.green,
                    ),
                    title: Text(
                        folderController.folder.cards[index].frontDescription),
                    subtitle: folderController.folder.cards[index].timeToStudy
                                .compareTo(DateTime.now()) >
                            0
                        ? Text(
                            "${folderController.folder.cards[index].timeToStudy}")
                        : const Text(""),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteCardDialog(index),
                    ),
                    onTap: () {
                      folderController.showBack = false;
                      _showCardDialog(
                          context, folderController.folder.cards[index]);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
