import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:dainik_media_newsapp/Home/webstories.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dainik Media'),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 42, 19, 133),
        unselectedItemColor: Color.fromARGB(255, 53, 42, 48),
       showUnselectedLabels: true, 
        currentIndex: _currentIndex,
        onTap: (index) {
          // Change the tab when a bottom navigation item is tapped
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              
             
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper, ),
            label: 'Daily News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article, ),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              
            ),
            label: 'web Stories',
          ),
        ],
      ),
    );
  }

  List<Widget> _tabs = [
    DainikMedia(
      newsapi: 'https://danikmedia.com/wp-json/wp/v2/posts?per_page=11',
    ),
    DainikMedia(
        newsapi: 'https://graamsetu.com/wp-json/wp/v2/posts?per_page=11'),
     DainikMedia(
    newsapi: 'https://bhatnerpost.com/wp-json/wp/v2/posts?per_page=11'),
    WebStories(
        newsapi: 'https://danikmedia.com/wp-json/web-stories/v1/web-story')
  ];
}
