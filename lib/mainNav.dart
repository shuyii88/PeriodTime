import 'package:flutter/material.dart';
import 'package:periodtime/profile_repository.dart';
import 'homepage.dart';
import 'setting_page.dart';

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  final ProfileRepository _profileRepository = ProfileRepository.instance;
  bool isLoading = true;

  final List<Widget> _pages = [
    HomePage(),
    Center(child: Text('Tracker')),
    Center(child: Text('Insights')),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _profileRepository.loadUserData().then((_) => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}


