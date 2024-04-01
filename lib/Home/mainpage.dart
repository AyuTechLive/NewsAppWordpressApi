import 'dart:io';

import 'package:dainik_media_newsapp/Colors.dart';
import 'package:dainik_media_newsapp/Home/dainikmedianew.dart';
import 'package:dainik_media_newsapp/Home/webstories.dart';
import 'package:dainik_media_newsapp/Utils/snackbar.dart';
import 'package:dainik_media_newsapp/inappopener.dart';
import 'package:dainik_media_newsapp/sidemenu/sidemenucard.dart';
import 'package:dainik_media_newsapp/sidemenu/sidemenuitems.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  DateTime? currentBackPressTime;

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
    List<SideMenuItem> sideMenuItems = [
      SideMenuItem(
        title: 'Instagram',
        iconPath: 'instagram1',
        onTap: () {
          _launchURL('https://www.instagram.com/danikmedia/');
          // Define the action for Item 2 onTap
        },
      ),
      SideMenuItem(
        title: 'Facebook',
        iconPath: 'facebook2',
        onTap: () {
          _launchURL('https://www.facebook.com/danikmedia');
          // Define the action for Item 2 onTap
        },
      ),
      SideMenuItem(
        title: 'Twitter',
        iconPath: 'twitter',
        onTap: () {
          _launchURL('https://twitter.com/danikmedia');
          //  onShare(context);
          // Define the action for Item 2 onTap
        },
      ),
      SideMenuItem(
        title: 'Telegram',
        iconPath: 'telegram1',
        onTap: () {
          // Utils().toastMessage('Feature Under Development');
          _launchURL('https://t.me/danikmedia');
          // Define the action for Item 1 onTap
          // e.g., Navigator.push(...), setState(...), etc.
        },
      ),

      SideMenuItem(
        title: 'Privacy Policy',
        iconPath: 'privacypolicy',
        onTap: () {
          // _launchURL('https://danikmedia.com/privacy-policy-2/');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InappOpener(
                    url: 'https://danikmedia.com/privacy-policy-2/',
                    title: 'Privacy Policy'),
              ));
          // Define the action for Item 2 onTap
        },
      ),
      SideMenuItem(
        title: 'About Us',
        iconPath: 'aboutus',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InappOpener(
                    url: 'https://danikmedia.com/about-us/', title: 'About Us'),
              ));

          // Define the action for Item 2 onTap
        },
      ),

      // Add more SideMenuItem objects for additional items
    ];
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            MySnackbar.show(context, 'Press Back Again to exit');

            return false;
          }
          exit(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Opens the drawer
                },
              );
            },
          ),
          title: Text(
            'Danik Media',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.06),
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.277,
                      height: height * 0.125,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 3,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/logo.png',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width * 0.025),
              Padding(
                padding: EdgeInsets.only(left: width * 0.1),
                child: Text(
                  'Danik Media',
                  //  checkUserAuthenticationType(),
                  style: TextStyle(
                    color: Color(0xFF565656),
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03875),
              Expanded(
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.0388),
                    child: Container(
                      width: 4,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.036, right: width * 0.075),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return SideMenuCrad(
                            title: sideMenuItems[index].title,
                            iconname: sideMenuItems[index].iconPath,
                            ontap: sideMenuItems[index].onTap,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: height * 0.025);
                        },
                        itemCount: 6,
                      ),
                    ),
                  ),
                ]),
              ),
            ],
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
          selectedItemColor: AppColors.backgroundColor,
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
              icon: Image.asset(
                'assets/icons/gramsetuicon.png',
                scale: 15,
              ),
              label: 'Gram Setu',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/bhatnericon.png',
                scale: 8,
              ),
              label: 'Bhatner Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              label: 'Web Stories',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
  }
}
