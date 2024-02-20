import 'package:dainik_media_newsapp/Categories/categories.dart';
import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Home/mainpage.dart';
import 'package:dainik_media_newsapp/Home/testing.dart';
import 'package:dainik_media_newsapp/Home/webstoryopener.dart';
import 'package:dainik_media_newsapp/Splashscreen/splashscreen.dart';
import 'package:dainik_media_newsapp/Testing/test2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Danik Media',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff2596BE),
            // brightness: Brightness.dark,
          ),

          useMaterial3: true,
        ),
        home: MainPage());
  }
}
