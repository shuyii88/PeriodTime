import 'package:flutter/material.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  DateTime? _startDate;
  DateTime? _estimateEndDate;
  int? _averageCycle;
  String _flowIntensity = 'Light';
  Map<String, bool> _symptoms = {
    'Cramps': false,
    'Headache': false,
    'Mood Swings': false,
  };

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Simple estimate: add average cycle if exists
        if (_averageCycle != null) {
          _estimateEndDate = picked.add(Duration(days: _averageCycle!));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Tracker'),
        backgroundColor: Colors.pink[100],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Period',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Colors.purple),
            ),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDateField(
                      'Start Date',
                      _startDate != null
                          ? _startDate!.toLocal().toString().split(' ')[0]
                          : 'Recorded selected date',
                      _pickStartDate,
                    ),
                    SizedBox(height: 12),
                    _buildDateField(
                      'Estimate End Date',
                      _estimateEndDate != null
                          ? _estimateEndDate!.toLocal().toString().split(' ')[0]
                          : 'Date',
                      () {},
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      'Average Period Cycle',
                      _averageCycle != null
                          ? '$_averageCycle Days'
                          : 'xxx Days',
                      (val) {
                        final days = int.tryParse(val);
                        if (days != null) {
                          setState(() {
                            _averageCycle = days;
                            if (_startDate != null) {
                              _estimateEndDate = _startDate!.add(
                                Duration(days: days),
                              );
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Flow Intensity',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.purple),
            ),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      ['Light', 'Medium', 'Heavy'].map((level) {
                        return Column(
                          children: [
                            Radio<String>(
                              value: level,
                              groupValue: _flowIntensity,
                              onChanged: (val) {
                                setState(() => _flowIntensity = val!);
                              },
                            ),
                            Text(level),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Symptoms & Mood',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.purple),
            ),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _symptoms.keys.map((sym) {
                        return Row(
                          children: [
                            Checkbox(
                              value: _symptoms[sym],
                              onChanged: (val) {
                                setState(() => _symptoms[sym] = val!);
                              },
                            ),
                            Text(sym),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Cycle Predictions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.purple),
            ),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Period:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _estimateEndDate != null
                              ? '${_estimateEndDate!.day} ${_monthName(_estimateEndDate!)} ${_estimateEndDate!.year}'
                              : '15th November 2025',
                        ),
                      ],
                    ),
                    Icon(Icons.show_chart, size: 48, color: Colors.purple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  String _monthName(DateTime dt) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[dt.month - 1];
  }
}
