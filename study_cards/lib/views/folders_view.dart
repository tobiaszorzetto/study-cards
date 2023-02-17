import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
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
      body: SizedBox(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                 Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCardPage(folder: folder),
              ),);
              }),
              child: const Text("Add Card"),
            ),
            _showFolders(context),
            _showCards(context),
          ],
        ),
      ),
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FolderPage(folder: folder.subFolders[index]),
                          )); 
                        }),
                      );
                    }
                    ),
                ),
      ],
    );
  }
  
  
  Future<void> _showCardDialog(BuildContext context,CardModel card) async {
    //final image = await  card.frontNotifier.renderImage();
    card.frontNotifier.setAllowedPointersMode(ScribblePointerMode.penOnly);
  showDialog(
      context: context,
      builder: (context) => SizedBox(
        child: AlertDialog(
          content: Column(
            children: [
              Text(card.frontDescription),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 2,
                child: Scribble(
                  notifier: card.frontNotifier,
                  )
                )
            ],
          ),
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
                        onTap: () => _showCardDialog(context, folder.cards[index]),
                      );
                    }
                    ),
                ),
      ],
    );
  }
}