import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/controllers/add_card_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/folders_view.dart';

class AddCardPage extends StatefulWidget {
  FolderModel folder;
  AddCardPage({super.key, required this.folder});

  @override
  State<AddCardPage> createState() => _AddCardPageState(folder);
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  
  late AddCardController controller;
  _AddCardPageState(folder){
    controller = AddCardController(folder);
  }
  

  @override
  void initState() {
    controller.notifierFront = ScribbleNotifier();
    controller.notifierBack = ScribbleNotifier();
    controller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.animation = Tween(end: 1.0, begin: 0.0).animate(controller.animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        controller.animationStatus = status;
      });
    super.initState();
    //_initRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text("Add Card"),
            leading: IconButton(
                onPressed: () => setState(() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FolderPage(folder: controller.folder),),);
                }),
                icon: const Icon(Icons.arrow_back)
              ),
          ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _changeCardSideButton(),
              _showCard(),
              _addCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(2, 1, 0.0015)
          ..rotateY(pi * controller.animation.value),
        child: controller.animation.value <= 0.5 ? frontCard() : backCard(),
      ),
    );
  }

  Widget _changeCardSideButton() {
    return ElevatedButton.icon(
        onPressed: () {
          controller.changeCardSide();
        },
        icon: const Icon(Icons.change_circle_outlined),
        label: controller.animationStatus == AnimationStatus.dismissed
            ? const Text("front")
            : const Text("back"));
  }


  Widget _buildEraserButton(ScribbleNotifier notifier) {
    controller.drawingColor = Colors.white;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: controller.eraseSelected ? 10 : 2,
        shape: !controller.eraseSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: () => setState(() {
          if (controller.eraseSelected) {
            controller.eraseSelected = false;
            notifier.setColor(Colors.black);
          } else {
            controller.eraseSelected = true;
            notifier.setEraser();
            
          }
        }),
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleNotifier notifier,
  }) {
    controller.drawingColor = color;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          heroTag: "btn${color.toString()}" ,
          backgroundColor: color,
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildStrokeSlider(
    BuildContext context, {
    required ScribbleNotifier notifier,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Slider(
        min: 1,
        max: 10,
        activeColor: controller.drawingColor,
        inactiveColor: controller.drawingColor,
        thumbColor: controller.drawingColor,
        divisions: 9,
        label: controller.stroke.toString(),
        value: controller.stroke,
        onChanged: (value) => setState(() {
          controller.stroke = value;
          notifier.setStrokeWidth(controller.stroke);
        })
      ),
    );
  }

  Widget _toolBar(BuildContext context, ScribbleNotifier notifier) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildEraserButton(notifier),
                _buildColorButton(context, color: Colors.black, notifier: notifier),
                _buildColorButton(context, color: Colors.red, notifier: notifier),
                _buildColorButton(context, color: Colors.blue, notifier: notifier),
              ],
            ),
          ),
          Expanded(child: _buildStrokeSlider(context, notifier: notifier)),
          //_buildRecordButton(),
        ],
      ),
      trailing: Checkbox(
        value: controller.showFrontSide? controller.showImageFront:controller.showImageBack , 
        onChanged: (value) => setState(() {
          controller.showFrontSide? controller.showImageFront = value! :controller.showImageBack = value!;
        })
      ),
    );
  }

  Card showCardSide(){
    return Card(
      child: Column(
        children: [
          TextField(
            controller: controller.showFrontSide? controller.frontTextController:controller.backTextController,
            maxLines: null,
          ),
          Visibility(
            visible: controller.showFrontSide? !controller.showImageFront:!controller.showImageBack,
            child: CheckboxListTile(
              title: const Text("Draw"),
              value: controller.showFrontSide? controller.showImageFront:controller.showImageBack, 
              onChanged: (value) => setState(() {
                controller.showFrontSide? controller.showImageFront = value!:controller.showImageBack = value!;
              })
            ),
          ),
          Visibility(
            visible: controller.showFrontSide? controller.showImageFront:controller.showImageBack,
            child: _toolBar(context, controller.showFrontSide? controller.notifierFront: controller.notifierBack),
          ),
          const Divider(),
          Visibility(
          visible: controller.showFrontSide? controller.showImageFront:controller.showImageBack,
          child: Expanded(
            child: Scribble(
              notifier: controller.showFrontSide? controller.notifierFront: controller.notifierBack,
              drawPen: true,
            ),
          ),
      ),
        ],
      ),
    );
  }


  Card frontCard() {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: controller.frontTextController,
            maxLines: null,
          ),
          Visibility(
            visible: !controller.showImageFront,
            child: CheckboxListTile(
              title: const Text("Draw"),
              value: controller.showImageFront, 
              onChanged: (value) => setState(() {
                controller.showImageFront = value!;
              })
            ),
          ),
          Visibility(
            visible: controller.showImageFront,
            child: _toolBar(context, controller.notifierFront),
          ),
          const Divider(),
          Visibility(
          visible: controller.showImageFront,
          child: Expanded(
            child: Scribble(
              notifier: controller.notifierFront,
              drawPen: true,
            ),
          ),
      ),
        ],
      ),
    );
  }

  Card backCard() {
    
    return Card(
      child: Stack(
        children: [
          
          Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..setEntry(2, 1, 0.0015)
              ..rotateY(pi),
            child: Column(
              children: [
                TextField(
                  controller: controller.backTextController,
                  maxLines: null,
                ),
                Visibility(
                  visible: !controller.showImageBack,
                  child: CheckboxListTile(
                    title: const Text("Draw"),
                    value: controller.showImageBack, 
                    onChanged: (value) => setState(() {
                      controller.showImageBack = value!;
                    })
                  ),
                ),
                Visibility(
                  visible: controller.showImageBack,
                  child: _toolBar(context, controller.notifierBack)
                ),
                Expanded(
                  child: Visibility(
                    visible: controller.showImageBack,
                    child: Scribble(
                      notifier: controller.notifierBack,
                      drawPen: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  
  
  _addCard() {
    return ElevatedButton(
      onPressed: () => setState(() {
        controller.addCard();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FolderPage(folder: controller.folder),
              ),);
        
      }),
      child: const Text("Add"),
      );
  }
}
