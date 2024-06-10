import 'package:isdfinal/BookScreen.dart';
import 'package:isdfinal/home_page.dart';
import 'package:isdfinal/profile.dart';

import 'books.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children:  [
          BookUploadPage(),
          const HomePage(),
          const UserProfile()
        ],
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        color: Colors.purple,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.purple,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        gap: 3,
        selectedIndex: _currentIndex,
        tabs: [
          GButton(icon: Icons.create_new_folder_sharp, text: 'Upload a Book'),
          GButton(icon: Icons.home, text: 'Home Page'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
