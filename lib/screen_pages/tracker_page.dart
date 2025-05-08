import 'package:flutter/material.dart';
//import 'package:periodtime/setting_page.dart';
import '../repositories/profile_repository.dart';
import 'package:intl/intl.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final _profileRepository = ProfileRepository.instance;

  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _periodLengthController = TextEditingController();

  DateTime? _lastPeriodDate;
  DateTime? _nextPeriod;
  //DateTime? _ovulation;

  DateTime? _fertileStart;
  DateTime? _fertileEnd;
  DateTime? _ovulationStart;
  DateTime? _ovulationEnd;
  DateTime? _safeBeforeStart;
  DateTime? _safeBeforeEnd;
  DateTime? _safeAfterStart;
  DateTime? _safeAfterEnd;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadSavedData();
    _calculateDates();
  }

  Future<void> _loadSavedData() async {
    _cycleLengthController.text =
        _profileRepository.cycleLength?.toString() ?? '0';
    _periodLengthController.text =
        _profileRepository.periodLength?.toString() ?? '0';
    _lastPeriodDate = _profileRepository.lastPeriodDate;
  }

  Future<void> _saveChanges() async {
    try {
      await _profileRepository.savePeriodData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }

  void _pickLastPeriodDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
        _profileRepository.lastPeriodDate = picked;
      });
    }
  }

  void _calculateDates() {
    if (_cycleLengthController.text.isEmpty ||
        _periodLengthController.text.isEmpty ||
        _lastPeriodDate == null) {
      _showError("Please complete all fields.");
      return;
    }

    try {
      int cycleLength = int.parse(_cycleLengthController.text);
      int periodLength = int.parse(_periodLengthController.text);

      DateTime ovulation = _lastPeriodDate!.add(Duration(days: cycleLength - 14));
      DateTime nextPeriod = _lastPeriodDate!.add(Duration(days: cycleLength));

      DateTime fertileStart = ovulation.subtract(Duration(days: 5));
      DateTime fertileEnd = ovulation.add(Duration(days: 1));

      DateTime ovulationStart = ovulation.subtract(Duration(days: 1));
      DateTime ovulationEnd = ovulation.add(Duration(days: 1));

      DateTime safeBeforeStart = _lastPeriodDate!;
      DateTime safeBeforeEnd = fertileStart.subtract(Duration(days: 1));

      DateTime safeAfterStart = fertileEnd.add(Duration(days: 1));
      DateTime safeAfterEnd = nextPeriod;

      setState(() {
        _nextPeriod = nextPeriod;
        //_ovulation = ovulation;
        _fertileStart = fertileStart;
        _fertileEnd = fertileEnd;
        _ovulationStart = ovulationStart;
        _ovulationEnd = ovulationEnd;
        _safeBeforeStart = safeBeforeStart;
        _safeBeforeEnd = safeBeforeEnd;
        _safeAfterStart = safeAfterStart;
        _safeAfterEnd = safeAfterEnd;
      });

      _profileRepository.cycleLength = cycleLength;
      _profileRepository.periodLength = periodLength;

      _saveChanges();
    } catch (e) {
      _showError("Invalid input. Please enter valid numbers.");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Icon(icon, color: Colors.deepPurple[200], size: 48),
        ],
      ),
    );
  }

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "Insufficient Data to Work With";
    return "${DateFormat.MMMd().format(start)} → ${DateFormat.MMMd().format(end)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.calendar_today, color: Colors.black),
        title: Text('Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
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

              TextField(
                controller: _cycleLengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cycle Length (days)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _periodLengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Period Length (days)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    _lastPeriodDate == null
                        ? "Select Last Period Date"
                        : "Last Period: ${DateFormat.yMMMMd().format(_lastPeriodDate!)}",
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _pickLastPeriodDate,
                    child: Text("Pick Date"),
                  ),
                ],
              ),

              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _calculateDates,
                  child: Text("Calculate & Save"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                ),
              ),
              SizedBox(height: 24),

              Text(
                "Cycle Predictions",
                style: TextStyle(fontSize: 22, color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),

              _buildPredictionCard(
                label: "Next Period:",
                value: _nextPeriod != null
                    ? DateFormat.yMMMMd().format(_nextPeriod!)
                    : "Insufficient Data to Work With",
                icon: Icons.calendar_today,
              ),
              _buildPredictionCard(
                label: "Ovulation Window:",
                value: _formatRange(_ovulationStart, _ovulationEnd),
                icon: Icons.waves,
              ),
              _buildPredictionCard(
                label: "Fertile Window:",
                value: _formatRange(_fertileStart, _fertileEnd),
                icon: Icons.favorite,
              ),
              _buildPredictionCard(
                label: "Safe Days (Before Fertile Window):",
                value: _formatRange(_safeBeforeStart, _safeBeforeEnd),
                icon: Icons.check_circle,
              ),
              _buildPredictionCard(
                label: "Safe Days (After Fertile Window):",
                value: _formatRange(_safeAfterStart, _safeAfterEnd),
                icon: Icons.check_circle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}