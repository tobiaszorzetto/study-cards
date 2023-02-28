import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_cards/controllers/study_cards_controller.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/views/folders_view.dart';

import '../file_manager.dart';
import '../models/folder_model.dart';

class StudyCardsPage extends StatefulWidget {
  FolderModel folder;
  List<CardModel> cardsToStudy;
  StudyCardsPage({super.key, required this.folder, required this.cardsToStudy});

  @override
  State<StudyCardsPage> createState() => _StudyCardsPageState(folder,cardsToStudy);
}

class _StudyCardsPageState extends State<StudyCardsPage>{

  late StudyCardsController controller;

  _StudyCardsPageState(folder,cardsToStudy){
    controller = StudyCardsController(folder, cardsToStudy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            Navigator.of(context).pop;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FolderPage(folder: controller.folder)
            ));
          }),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => setState(() {
              controller.lastCard();
            }), 
            icon: const Icon(Icons.arrow_back_ios_new)
          ),
          controller.cardsToStudy.length != controller.cardsStudied.length? _showCard() : const Text("No more cards to study"),
          IconButton(
            onPressed: () => setState(() {
              controller.nextCard();
            }),  
            icon: const Icon(Icons.arrow_forward_ios)
          ),
        ],
      ),
    );
  }

  Widget _showCard(){
    String folderPath = FileManager.instance.getFolderImagePath(controller.folder);
    File frontCardFile = File("$folderPath\\${controller.folder.cards[controller.indexCardShowing].frontDescription}0");
    File backCardFile = File("$folderPath\\${controller.folder.cards[controller.indexCardShowing].frontDescription}1");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 400,
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !controller.showAnswer,
                  child: Card(
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _showImageInDialog(frontCardFile, controller.folder.cards[controller.indexCardShowing],controller.folder.cards[controller.indexCardShowing].frontDescription),
                            ElevatedButton(
                              onPressed: () => setState(() {
                                controller.showAnswer = !controller.showAnswer;
                              }), 
                              child: const Icon(Icons.arrow_downward)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.showAnswer,
                  child: Card(
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => setState(() {
                                controller.showAnswer = !controller.showAnswer;
                              }), 
                              child: const Icon(Icons.arrow_upward)
                            ),
                            _showImageInDialog(backCardFile, controller.folder.cards[controller.indexCardShowing],controller.folder.cards[controller.indexCardShowing].backDescription),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    controller.cardsToStudy[controller.indexCardShowing].timeToStudy = DateTime.now();
                                    controller.cardsStudied.add(controller.indexCardShowing);
                                    controller.nextCard();
                                  }), 
                                  child: const ListTile(
                                    title: Text("Try again"),
                                    subtitle: Text("0 min"),
                                  )
                                  )),
                                Expanded(child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    controller.cardsToStudy[controller.indexCardShowing].timeToStudy = DateTime.now().add(const Duration(minutes: 10));
                                    controller.cardsStudied.add(controller.indexCardShowing);
                                    controller.nextCard();
                                  }), 
                                  child: const ListTile(
                                    title: Text("Hard"),
                                    subtitle: Text("10 min"),
                                  )
                                  )),
                                Expanded(child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    controller.cardsToStudy[controller.indexCardShowing].timeToStudy = DateTime.now().add(const Duration(days: 1));
                                    controller.cardsStudied.add(controller.indexCardShowing);
                                    controller.nextCard();
                                  }), 
                                  child: const ListTile(
                                    title: Text("Medium"),
                                    subtitle: Text("1 day"),
                                  )
                                  )),
                                Expanded(child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    controller.cardsStudied.add(controller.indexCardShowing);
                                    controller.cardsToStudy[controller.indexCardShowing].timeToStudy = DateTime.now().add(const Duration(days: 6));
                                    controller.nextCard();
                                  }), 
                                  child: const ListTile(
                                    title: Text("Easy"),
                                    subtitle: Text("6 days"),
                                  )
                                  )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showImageInDialog(File file, CardModel card, String text){
    
    try {
      return Column(
        children: [
          Text(text),
          
          Image.file(file),
        ],
      );
    } catch (e) {
      return Text(text);
    }

  }

}
