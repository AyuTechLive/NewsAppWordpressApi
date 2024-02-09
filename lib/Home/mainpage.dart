import 'package:dainik_media_newsapp/Home/dainikmedianew.dart';
import 'package:dainik_media_newsapp/Home/webstories.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            );
          },
        ),
        title: Text(
          'Danik Media',
          style: TextStyle(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          DainikMedia2(newsapi: 'https://danikmedia.com/wp-json/wp/v2/'),
          DainikMedia2(newsapi: 'https://graamsetu.com/wp-json/wp/v2/'),
          DainikMedia2(newsapi: 'https://bhatnerpost.com/wp-json/wp/v2/'),
          WebStories(
              newsapi:
                  'https://danikmedia.com/wp-json/web-stories/v1/web-story'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 42, 19, 133),
        unselectedItemColor: Color.fromARGB(255, 53, 42, 48),
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          // Change the tab when a bottom navigation item is tapped
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
            ),
            label: 'Daily News',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article,
            ),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            label: 'Web Stories',
          ),
        ],
      ),
    );
  }
}
