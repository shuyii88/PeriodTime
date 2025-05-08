// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/advice_repository.dart';
import '../repositories/profile_repository.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onTabChanged;
  const HomePage({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _profileRepository = ProfileRepository.instance;
  final _adviceRepo = AdviceRepository.instance;

  int? _daysUntilNextPeriod;
  String? _lastPeriodText;
  CyclePhase? _currentPhase;
  String _todayAdvice = '';
  String _healthTip = '';

  @override
  void initState() {
    super.initState();
    _loadPredictionInfo();
  }

  void _loadPredictionInfo() {
    final lastPeriod = _profileRepository.lastPeriodDate;
    final cycleLength = _profileRepository.cycleLength;
    final periodLength = _profileRepository.periodLength;

    if (lastPeriod != null && cycleLength != null && periodLength != null) {
      final now = DateTime.now();
      final nextPeriod = lastPeriod.add(Duration(days: cycleLength));
      final daysLeft = nextPeriod.difference(now).inDays;

      // Determine phase
      final phase = _adviceRepo.determinePhase(
        lastPeriod: lastPeriod,
        cycleLength: cycleLength,
        periodLength: periodLength,
      );

      // Fetch random advice and tip for today
      final advice = _adviceRepo.getRandomAdvice(phase);
      final tip    = _adviceRepo.getRandomTip(phase);

      setState(() {
        _daysUntilNextPeriod = daysLeft;
        _lastPeriodText = DateFormat.yMMMMd().format(lastPeriod);
        _currentPhase = phase;
        _todayAdvice = advice;
        _healthTip = tip;
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
          child: _profileRepository.lastPeriodDate == null ||
              _profileRepository.cycleLength == null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              Center(
                child: Text(
                  "To begin tracking your cycle,\nplease set up your data on the Tracker page.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onTabChanged(1),
                  icon: Icon(Icons.open_in_new),
                  label: Text("Go to Tracker"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                'Welcome, ${_profileRepository.usernameController.text}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 24),
              // Next Period Circle
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
                      Text(
                        'Next Period In',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _daysUntilNextPeriod != null
                            ? '$_daysUntilNextPeriod Days'
                            : '--',
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

              // Today's Advice & Health Tip
              InfoCard(
                title: "Today's Advice",
                content: _todayAdvice,
              ),
              SizedBox(height: 16),
              InfoCard(
                title: 'Health Tip',
                content: _healthTip,
              ),
              SizedBox(height: 32),

              // Reminder & Summary
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Reminder',
                      content: _currentPhase != null
                          ? _currentPhase == CyclePhase.period
                          ? 'Today is a period day.'
                          : _currentPhase == CyclePhase.fertile
                          ? 'Today is a fertile window.'
                          : 'Today is a safe day.'
                          : 'Cycle status unavailable',
                      minHeight: 100,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      title: 'Summary',
                      content: 'Last Period\n$_lastPeriodText',
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
          Text(content, style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
