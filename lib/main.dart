import 'package:downlink/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  runApp(MyApp());
}

Color titleColor = Color.fromRGBO(30, 215, 96, 1);
Color backgroundColor = Color.fromRGBO(25, 20, 20, 1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //Default settings
        primaryColor: backgroundColor,
        brightness: Brightness.dark,

        //Default Text Styles
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: titleColor),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 16),
        ),

        //Default background
        scaffoldBackgroundColor: backgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
