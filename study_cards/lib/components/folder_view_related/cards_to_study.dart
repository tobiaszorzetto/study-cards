import 'package:flutter/material.dart';
import '../../controllers/folder_controller.dart';
import '../../views/study_cards_page.dart';

class CardsToStudy extends StatelessWidget {
  final FolderController folderController;

  const CardsToStudy({
    super.key,
    required this.folderController,
  });

  @override
  Widget build(BuildContext context) {
    folderController.setCardsToStudy();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: Text(
                          "${folderController.cardsToStudy.length}",
                          style: TextStyle(
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
                      child: Container(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          left: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: FittedBox(
                          child: Text(
                            "Cards pending studying",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
