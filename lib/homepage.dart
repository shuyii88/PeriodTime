//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'tracker_page.dart';
import 'profile_repository.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _profileRepository = ProfileRepository.instance;

  int? _daysUntilNextPeriod;
  String? _lastPeriodText;

  @override
  void initState() {
    super.initState();
    _loadPredictionInfo();
  }

  void _loadPredictionInfo() {
    final lastPeriod = _profileRepository.lastPeriodDate;
    final cycleLength = _profileRepository.cycleLength;

    if (lastPeriod != null && cycleLength != null) {
      final nextPeriod = lastPeriod.add(Duration(days: cycleLength));
      final now = DateTime.now();
      final daysLeft = nextPeriod.difference(now).inDays;

      setState(() {
        _daysUntilNextPeriod = daysLeft;
        _lastPeriodText = DateFormat.yMMMMd().format(lastPeriod);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.home, color: Colors.black),
        title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                'Welcome, ${_profileRepository.usernameController.text}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[900]),
              ),
              SizedBox(height: 24),

              // Circle displaying days left
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.pink[700],
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next Period In', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      SizedBox(height: 8),
                      Text(
                        _daysUntilNextPeriod != null ? '$_daysUntilNextPeriod Days' : '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Tips
              InfoCard(
                title: "Today's Advice",
                content:
                'Stay hydrated and incorporate light exercises into your routine to ease cramps.',
              ),
              SizedBox(height: 16),
              InfoCard(
                title: 'Health Tip',
                content:
                "Include iron-rich foods to replenish your body's nutrients.",
              ),
              SizedBox(height: 32),

              // Upcoming & Last Period Info
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Reminder',
                      content: _daysUntilNextPeriod != null
                          ? 'Upcoming Period\nin $_daysUntilNextPeriod days'
                          : 'Upcoming Period\nUnavailable',
                      minHeight: 100,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      title: 'Summary',
                      content: _lastPeriodText != null
                          ? 'Last Period\n$_lastPeriodText'
                          : 'Last Period\nUnavailable',
                      minHeight: 100,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final double minHeight;

  const InfoCard({
    Key? key,
    required this.title,
    required this.content,
    this.minHeight = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
