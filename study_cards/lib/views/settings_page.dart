import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_cards/controllers/settings_controller.dart';
import 'package:study_cards/models/folder_model.dart';
import 'package:study_cards/views/create_account_page.dart';
import 'package:study_cards/views/folders_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../file_manager.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(child: durationToStudySettings()),
          ],
        ),
      ),
    );
  }

  Widget durationToStudySettings() {
    return ListView(
      children: [
        Text("Durations to study"),
        ListTile(
          leading: Text("medium"),
          title: Text(SettingsController.instance.timesToStudy[0].toString()),
          trailing: IconButton(
              onPressed: () {
                createDurationDialog();
              },
              icon: Icon(Icons.edit)),
        )
      ],
    );
  }

  createDurationDialog() {
    showDialog(
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customRadioButton("minutes", 0),
                    customRadioButton("hours", 1),
                    customRadioButton("days", 2),
                  ],
                )),
                DurationPicker(onChange: (val) {}),
              ],
            ));
  }

  Widget customRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          value = index;
        });
      },
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: (value == index) ? Colors.green : Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: (value == index) ? Colors.green : Colors.black,
        ),
      ),
    );
  }
}
