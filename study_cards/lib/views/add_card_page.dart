import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:scribble/scribble.dart';
import 'package:study_cards/models/card_model.dart';
import 'package:study_cards/models/folder_model.dart';

class AddCardPage extends StatefulWidget {
  FolderModel folder;
  AddCardPage({super.key, required this.folder});

  @override
  State<AddCardPage> createState() => _AddCardPageState(folder);
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  late ScribbleNotifier notifierFront;
  late ScribbleNotifier notifierBack;
  late TextEditingController frontTextController = TextEditingController();
  late TextEditingController backTextController = TextEditingController();

  bool eraseSelected = false;

  bool showFrontSide = true;

  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  final recorder = FlutterSoundRecorder();
  
  FolderModel folder;
  _AddCardPageState(this.folder);

  @override
  void initState() {
    notifierFront = ScribbleNotifier();
    notifierBack = ScribbleNotifier();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
    //_initRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text(widget.title),

          ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _changeCardSideButton(),
                _showCard(),
                _addCard(),
              ],
            ),
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
          ..rotateY(pi * _animation.value),
        child: Card(
          child: _animation.value <= 0.5 ? frontCard() : backCard(),
        ),
      ),
    );
  }

  Widget _changeCardSideButton() {
    return ElevatedButton.icon(
        onPressed: () {
          if (_status == AnimationStatus.dismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        icon: Icon(Icons.change_circle_outlined),
        label: _status == AnimationStatus.dismissed
            ? Text("front")
            : Text("back"));
  }

  Future _initRecorder() async {
    await recorder.openRecorder();
  }

  Future record() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecording() async {
    await recorder.stopRecorder();
  }

  Widget _buildRecordButton() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        elevation: eraseSelected ? 10 : 2,
        shape: !eraseSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: recorder.isRecording
            ? const Icon(Icons.stop)
            : const Icon(Icons.record_voice_over),
        onPressed: () => setState(() {
          if (recorder.isStopped) {
            record();
          } else {
            stopRecording();
          }
        }),
      ),
    );
  }

  Widget _buildEraserButton(ScribbleNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: eraseSelected ? 10 : 2,
        shape: !eraseSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: () => setState(() {
          if (eraseSelected) {
            eraseSelected = false;
            notifier.setColor(Colors.black);
          } else {
            eraseSelected = true;
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
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          backgroundColor: color,
          //elevation: isSelected ? 10 : 2,
          /*shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),*/
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: () => setState(() => showFrontSide = !showFrontSide),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        child: showFrontSide ? frontCard() : backCard(),
      ),
    );
  }

  Widget _toolBar(BuildContext context, ScribbleNotifier notifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildEraserButton(notifier),
        _buildColorButton(context, color: Colors.black, notifier: notifier),
        _buildColorButton(context, color: Colors.red, notifier: notifier),
        _buildColorButton(context, color: Colors.blue, notifier: notifier),
        //_buildRecordButton(),
      ],
    );
  }

  Card frontCard() {
    return Card(
      child: Stack(
        children: [
          Scribble(
            notifier: notifierFront,
            drawPen: true,
          ),
          Column(
            children: [
              TextField(
                controller: frontTextController,
                maxLines: null,
              ),
              _toolBar(context, notifierFront),
            ],
          ),
        ],
      ),
    );
  }

  Card backCard() {
    return Card(
      child: Stack(
        children: [
          Scribble(
            notifier: notifierBack,
            drawPen: true,
          ),
          Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..setEntry(2, 1, 0.0015)
              ..rotateY(pi),
            child: Column(
              children: [
                TextField(
                  controller: backTextController,
                  maxLines: null,
                ),
                _toolBar(context, notifierBack),
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
        folder.cards.add(CardModel(frontDescription: frontTextController.text, backDescription: backTextController.text, frontNotifier: notifierFront, backNotifier: notifierBack));
        Navigator.of(context).pop();
      }),
      child: Text("Add"),
      );
  }
}
