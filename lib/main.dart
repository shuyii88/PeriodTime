import 'package:flutter/material.dart';
import 'package:periodtime/screen_pages/insight_page.dart';
import 'mainNav.dart';
import 'package:periodtime/screen_pages/start_page.dart';
import 'package:periodtime/screen_pages/register_page.dart';
import 'package:periodtime/screen_pages/login_page.dart';
import 'screen_pages/complete_profile_page.dart';
import 'package:periodtime/screen_pages/setting_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity, // Using Play Integrity for Android
  );

  runApp(PeriodTimeApp());
}


class PeriodTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Period Time',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/completeProfile': (context) => CompleteProfilePage(),
        '/setting': (context) => SettingPage(),
        '/mainNav': (context) => MainNav(),
        '/insight': (context) => InsightsPage(),
      },
    );
  }
}
