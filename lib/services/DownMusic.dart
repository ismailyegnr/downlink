import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;
import 'package:ext_storage/ext_storage.dart';

class DownloadMusic {
  requestPermission() async {
    var permissionStatus = await Permission.storage.status;

    if (!permissionStatus.isGranted) {
      if (!await Permission.storage.request().isGranted) {
        return false;
      }
      return true;
    }
    return true;
  }

  //trying to make youtube link a mp3 link
  makeDownloadable(url) async {
    var yt = YoutubeExplode();

    //Regexp to parse youtube link
    final urlCreator = new RegExp(
        "(?:[?&]v=|\/embed\/|\/1\/|\/v\/|https:\/\/(?:www\.)?youtu\.be\/)([^&\n?#]+)",
        caseSensitive: false,
        multiLine: false);
    String newUrl = url;

    var musicInfos;
    String musicTitle;

    if (urlCreator.hasMatch(newUrl)) {
      newUrl = urlCreator.firstMatch(newUrl).group(1);
      print(newUrl);

      musicInfos = await getDetail(url);

      musicTitle = musicInfos["title"];

      var streamManifest = await yt.videos.streamsClient.getManifest(newUrl);

      var streamInfo = streamManifest.audioOnly.withHighestBitrate();

      await finallyDownload(streamInfo.url.toString(), musicTitle);
    } else {
      print("Cannot parse $newUrl");
    }
  }

  finallyDownload(downloadLink, musicTitle) async {
    var firstPermission = await requestPermission();

    if (firstPermission == true) {
      var storagePath = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_MUSIC);

      print(storagePath);

      // ignore: unused_local_variable
      final taskId = await FlutterDownloader.enqueue(
          fileName: "$musicTitle.mp3",
          url: downloadLink,
          savedDir: storagePath,
          openFileFromNotification: true,
          showNotification: true);
    }
  }

  //Getting music infos from youtube link
  Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$userUrl&format=json";

    var res = await http.get(embedUrl);
    print("get youtube detail status code: " + res.statusCode.toString());

    try {
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());

      return null;
    }
  }
}
