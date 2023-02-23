import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import 'package:study_cards/file_manager.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/add_card_page.dart';

import '../models/card_model.dart';

class FolderPage extends StatefulWidget{
  FolderModel folder;

  FolderPage({required this.folder, super.key});

  @override
  State<FolderPage> createState() => _FolderPageState(folder);
}

class _FolderPageState extends State<FolderPage> {
  

  
  FolderModel folder;

  _FolderPageState(this.folder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            if (folder.parentFolder != null){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FolderPage(folder: folder.parentFolder!),
              )); 
            }
              
            
          }),
          ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => setState(() {
              FileManager.instance.saveCards();                                                                                 
            }),
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            Row(
              children: [
                _addCard(),
                _addFolderButton(),
              ],
            ),
            _showFolders(context),
            _showCards(context),
          ],
        ),
      ), 
    );
  }

  _addCard(){
    return ElevatedButton(
              onPressed: () => setState(() {

              Navigator.of(context).pop();
                 Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCardPage(folder: folder),
              ),);
              }),
              child: const Text("Add Card"),
            );
  }
  _addFolderButton(){
    return ElevatedButton(
              onPressed: () => setState(() {
                _createFolder();
              }),
              child: const Text("Add Folder"),
            );
  }

  _createFolder(){
    String folderName = "";
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Folder"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            onChanged: (value) => setState(() {
              folderName = value;
            }),
          ),
        ),
      actions: [
        ElevatedButton(
              onPressed: () => setState(() {
                FolderModel newSubFolder = FolderModel(name: folderName,parentFolder: folder);
                folder.subFolders.add(newSubFolder);
                print(FileManager.instance.getFolderImagePath(newSubFolder));
                Directory("${FileManager.instance.getFolderImagePath(newSubFolder)}").create();
                Navigator.of(context).pop();
                FileManager.instance.saveCards();
              }),
              child: const Text("Add"),
            )
      ],
      )
    );

  }

  _showFolders(BuildContext context){
    return Column(
      children: [
        Text("Folders"),
        SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: folder.subFolders.length,
                    itemBuilder: (buildContext, index) {
                      return ListTile(
                        title: Text(folder.subFolders[index].name),
                        onTap: () => setState(() {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FolderPage(folder: folder.subFolders[index]),
                          )); 
                        }),
                        trailing: IconButton(onPressed: () => _showDeleteFolderDialog(index), icon: const Icon(Icons.delete)),
                      );
                    }
                    ),
                ),
      ],
    );
  }
  
  
  Future<void> _showCardDialog(BuildContext context,CardModel card) async {
    String folderPath = FileManager.instance.getFolderImagePath(folder);
  File fileFront = File("$folderPath\\${card.frontDescription}0");
  bool fileFrontExists = await fileFront.exists(); 
  File fileBack = File("$folderPath\\${card.frontDescription}1");
  bool fileBackExists = await fileBack.exists(); 
    //final image = await  card.frontNotifier.renderImage();
  // ignore: use_build_context_synchronously
  await showDialog(
      context: context,
      builder: (context) => SizedBox(
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (context,setState) =>
            Column(
              children: [
                Text(card.frontDescription),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: _showCardInDialog(fileFrontExists, fileFront, card, card.frontDescription),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    FolderController.instance.showBack = !FolderController.instance.showBack;
                  }), 
                  child: const Text("Show Back")
                  ),
                Expanded(
                  child: Visibility(
                    visible: FolderController.instance.showBack,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: _showCardInDialog(fileBackExists, fileBack, card, card.backDescription),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _showCardInDialog(bool fileExists, File file, CardModel card, String text){
    if (fileExists){
      return Column(
        children: [
          Text(text),
          Expanded(child: Image.file(file)),
        ],
      );
    }
    return Text(text);
  }


  Future<void> _deleteImages(CardModel card, FolderModel folder) async{
    String folderPath = FileManager.instance.getFolderImagePath(folder);
    File file0 = File("$folderPath\\${card.frontDescription}0");
    File file1 = File("$folderPath\\${card.frontDescription}1");
    if(await file0.exists()){
      file0.delete();
    }
    if(await file1.exists()){
      file1.delete();
    }
  }

  Future<void> _deleteFolder(FolderModel folderDeleted) async{
    for (FolderModel subfolder in folderDeleted.subFolders){
      await _deleteFolder(subfolder);
    }
    for(CardModel card in folderDeleted.cards){
      await _deleteImages(card, folderDeleted);
    }
    await Directory(FileManager.instance.getFolderImagePath(folderDeleted)).delete();

  }

  _showDeleteCardDialog(int cardIndex){
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (context,setState) =>
            Text("Do you want to delete this card?")
          ),
          actions: [
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () => setState(() {
                Navigator.of(context).pop();
                _deleteImages(folder.cards[cardIndex], folder);
                folder.cards.remove(folder.cards[cardIndex]);
                FileManager.instance.saveCards();
              }), 
              child: Text("OK")
            ),
          ],
        ),
      )
      
    );
  }


  _showDeleteFolderDialog(int folderIndex){
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (context,setState) =>
            Text("Do you want to delete this folder?")
          ),
          actions: [
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () => setState(() {
                Navigator.of(context).pop();
                _deleteFolder(folder.subFolders[folderIndex]);
                folder.subFolders.remove(folder.subFolders[folderIndex]);
                FileManager.instance.saveCards();
              }), 
              child: Text("OK")
            ),
          ],
        ),
      )
      
    );
  }
  
  _showCards(BuildContext context) {
    return Column(
      children: [
        Text("Cards"),
        SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: folder.cards.length,
                    itemBuilder: (buildContext, index) {
                      return ListTile(
                        title: Text(folder.cards[index].frontDescription),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteCardDialog(index),
                        ),
                        onTap: () {
                          FolderController.instance.showBack = false;
                          _showCardDialog(context, folder.cards[index]);
                        },
                      );
                    }
                    ),
                ),
      ],
    );
  }
}