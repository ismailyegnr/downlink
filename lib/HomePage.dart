import 'package:downlink/services/DownMusic.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  DownloadMusic _music = DownloadMusic();
  String youtubeUrl;

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mp3 Downloader"),
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Paste your youtube link to download"),
                        _textField(),
                        _downloadButton(),
                      ],
                    ),
                  ),
                ),
                _premiumButton(),
              ],
            ),
          ),
        ));
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 34.0),
      child: TextFormField(
        onSaved: (newValue) {
          youtubeUrl = newValue;
        },
        validator: (value) {
          if (value.isEmpty) {
            return ("Enter a link");
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: "Paste link",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
      ),
    );
  }

  Widget _downloadButton() {
    return _isProcessing == true
        ? Theme(
            data: Theme.of(context).copyWith(accentColor: titleColor),
            child: new CircularProgressIndicator(),
          )
        : SizedBox(
            width: 220,
            height: 52,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              textColor: titleColor,
              highlightedBorderColor: titleColor,
              borderSide: BorderSide(color: titleColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_download,
                    size: 26,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Download",
                    ),
                  )
                ],
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  setState(() {
                    _isProcessing = true;
                  });
                  await _music.makeDownloadable(youtubeUrl);
                  setState(() {
                    _isProcessing = false;
                  });
                }
              },
            ),
          );
  }

  Widget _premiumButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 60,
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: backgroundColor),
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {},
              color: backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesome5.spotify,
                    color: titleColor,
                    size: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Download Spotify Musics",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
