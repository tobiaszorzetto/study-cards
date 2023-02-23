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
              FileManager.instance.getFiles();                                         
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
                folder.subFolders.add(FolderModel(name: folderName,parentFolder: folder));
                Directory("assets\\images\\${folderName}").create();
                Navigator.of(context).pop();
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
                        onLongPress: () => setState(() {
                          
                        }),
                      );
                    }
                    ),
                ),
      ],
    );
  }
  
  
  Future<void> _showCardDialog(BuildContext context,CardModel card) async {
  File fileFront = File("assets\\images\\${folder.name}\\${card.frontDescription}0");
  bool fileFrontExists = await fileFront.exists(); 
  File fileBack = File("assets\\images\\${folder.name}\\${card.frontDescription}1");
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
                  child: _showCardInDialog(fileFrontExists, fileFront, card),
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
                      child: _showCardInDialog(fileBackExists, fileBack, card),
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

  Widget _showCardInDialog(bool fileExists, File file, CardModel card){
    if (fileExists){
      return Column(
        children: [
          Text(card.backDescription),
          Expanded(child: Image.file(file)),
        ],
      );
    }
    print("a");
    return Text(card.backDescription);
  }

  Future<Image?> _showImage(File file) async{
    
    return null;
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