import 'package:flutter/material.dart';
import 'repositories/profile_repository.dart';
import 'package:periodtime/screen_pages/tracker_page.dart';
import 'screen_pages/homepage.dart';
import 'screen_pages/insight_page.dart';
import 'package:periodtime/screen_pages/setting_page.dart';

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  final ProfileRepository _profileRepository = ProfileRepository.instance;
  bool isLoading = true;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _profileRepository.clearUserData().then((_) {
      _profileRepository.loadPeriodData();
    });

    _profileRepository.loadUserData().then((_) {
      _pages = [
        HomePage(onTabChanged: _onTabChanged),
        TrackerPage(),
        InsightsPage(),
        SettingPage(),
      ];
      setState(() => isLoading = false);
    });
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
