import 'dart:async';

import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:dainik_media_newsapp/Home/mainpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          )),
    );
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.width;
    final double widht = screensize.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: ClipRRect(
                  child: Image.asset(
                'assets/icons/logo.png',
                scale: 2.0,
                fit: BoxFit.fill,
              )),
            ),

            //    Container(
            //       height: height * 0.55,
            //       width: widht * 0.27,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(50),
            //         child: Image.network(
            //           'https://firebasestorage.googleapis.com/v0/b/fir-d8752.appspot.com/o/WhatsApp%20Image%202023-12-19%20at%2019.32.33.jpeg?alt=media&token=3d6e78f0-0795-4043-86be-da547e2472f7',
            //           scale: 1.0,
            //           fit: BoxFit.fill,
            //         ),
            //       )),
            // )
          ),
        ]));
  }
}
