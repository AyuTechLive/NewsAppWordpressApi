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
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.width;
    final double widht = screensize.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent, // Set the background to transparent
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/icons/background.jpg', // replace with your image path
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Existing Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/icons/transparentlogo.png',
                      scale: 1.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
