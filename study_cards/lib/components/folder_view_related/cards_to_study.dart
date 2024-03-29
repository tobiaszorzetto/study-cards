import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/models/card_model.dart';
import '../../controllers/folder_controller.dart';
import '../../views/study_cards_page.dart';

class CardsToStudy extends StatelessWidget {
  final FolderController folderController;
  final User user;

  const CardsToStudy({
    super.key,
    required this.folderController, required this.user
  });

  @override
  Widget build(BuildContext context) {
    folderController.setCardsToStudy();
    return Expanded(
      flex: 2,
      child: Column(
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
                          cardsToStudy: folderController.cardsToStudy,
                          user: user,),
                    ))
                  : {},
              child: const Text("Study Cards"),
            ),
          )
        ],
      ),
    );
  }

  goToStudy(BuildContext context) async {

    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StudyCardsPage(
                          folder: folderController.folder,
                          cardsToStudy: folderController.cardsToStudy,
                          user: user,),
                    ));
  }
}
