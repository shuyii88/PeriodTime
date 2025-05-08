import 'dart:io';

import 'package:flutter/material.dart';
import 'profile_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _profileRepository = ProfileRepository.instance;

  //final String userName = _profileRepository.usernameController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header with Home Icon & Avatar ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.home, size: 28, color: Colors.grey[800]),
                  Text(
                    'HOME',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        _profileRepository.newImageFile != null
                            ? FileImage(_profileRepository.newImageFile!)
                            : (_profileRepository.imagePath != null &&
                                    File(
                                      _profileRepository.imagePath!,
                                    ).existsSync()
                                ? FileImage(File(_profileRepository.imagePath!))
                                : AssetImage('assets/image.jpeg')
                                    as ImageProvider),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // ─── Welcome Text ─────────────────────────────────────────────
              Text(
                'Welcome, ${_profileRepository.usernameController.text}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),

              SizedBox(height: 24),

              // ─── Days Left Circle ────────────────────────────────────────
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
                        'Current System Date',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '2 Days Left',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32),

              // ─── Advice & Tips Cards ─────────────────────────────────────
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

              // ─── Reminder & Summary Row ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Reminder',
                      content: 'Upcoming Period\n(Days)',
                      minHeight: 100,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      title: 'Summary',
                      // replace with an icon if you like
                      content: '😔 Last Period\n(Date)',
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
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.purple[800],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
