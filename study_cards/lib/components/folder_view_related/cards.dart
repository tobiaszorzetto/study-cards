import 'package:flutter/material.dart';
import 'package:study_cards/controllers/folder_controller.dart';
import '../../models/card_model.dart';
import 'add_card_button.dart';

class Cards extends StatelessWidget {
  void Function() gotoAddCardPage;
  void Function(int) showDeleteCardDialog;
  void Function(BuildContext, CardModel) showCardDialog;

  FolderController controller;
  Cards(
      {super.key,
      required this.gotoAddCardPage,
      required this.controller,
      required this.showDeleteCardDialog,
      required this.showCardDialog});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListTile(
                tileColor: const Color.fromARGB(255, 129, 169, 186),
                leading: const Icon(Icons.note),
                title: Text(
                  "Cards",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: GotoAddCardButton(
                  gotoAddCardPage: gotoAddCardPage,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: controller.folder.cards.length,
                  itemBuilder: (buildContext, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.circle,
                        color: controller.cardsToStudy
                                .contains(controller.folder.cards[index])
                            ? Colors.red
                            : Colors.green,
                      ),
                      title:
                          Text(controller.folder.cards[index].frontDescription),
                      subtitle: controller.folder.cards[index].timeToStudy
                                  .compareTo(DateTime.now()) >
                              0
                          ? Text(
                              "${controller.folder.cards[index].timeToStudy}")
                          : const Text(""),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDeleteCardDialog(index),
                      ),
                      onTap: () {
                        controller.showBack = false;
                        showCardDialog(context, controller.folder.cards[index]);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
