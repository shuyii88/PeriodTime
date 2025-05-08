import 'package:flutter/material.dart';
import 'package:periodtime/insight_page.dart';
import 'mainNav.dart';
import 'start_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'complete_profile_page.dart';
import 'setting_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(PeriodTimeApp());
}


class PeriodTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
