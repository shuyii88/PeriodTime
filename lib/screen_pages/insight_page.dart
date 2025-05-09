import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periodtime/screen_pages/webview_page.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({Key? key}) : super(key: key);

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late Future<Map<String, List<Insight>>> _futureInsights;

  @override
  void initState() {
    super.initState();
    _futureInsights = fetchInsightsFromFirestore();
  }

  Future<Map<String, List<Insight>>> fetchInsightsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('insights').get();

    Map<String, List<Insight>> categorized = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Other';

      final insight = Insight(
        title: data['title'] ?? '',
        summary: data['summary'] ?? '',
        url: data['url'] ?? '',
        icon: Insight.getIconFromName(data['iconName'] ?? 'lightbulb_outline'),
      );

      categorized.putIfAbsent(category, () => []).add(insight);
    }

    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Insight>>>(
      future: _futureInsights,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Period Insights')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Period Insights')),
            body: Center(child: Text('Error loading insights')),
          );
        } else {
          final categorizedInsights = snapshot.data!;
          final tabs = categorizedInsights.keys.toList();

          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: Colors.pink[50],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: Icon(Icons.favorite, color: Colors.black),
                title: Text('Period Insights', style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.pink[100],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
              body: TabBarView(
                children: tabs.map((tab) {
                  final insights = categorizedInsights[tab]!;
                  return ListView.builder(
                    itemCount: insights.length,
                    itemBuilder: (context, index) {
                      return InsightCard(insight: insights[index], category: tab);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}


class Insight {
  final String title;
  final String summary;
  final String url;
  final IconData icon;

  Insight(
      {required this.title, required this.summary, required this.url, required this.icon});

  String get iconName =>
      _iconNameMap.entries
          .firstWhere(
            (e) => e.value == icon,
        orElse: () =>
        const MapEntry('lightbulb_outline', Icons.lightbulb_outline),
      ).key;

  static IconData getIconFromName(String name) {
    return _iconNameMap[name] ?? Icons.lightbulb_outline;
  }

  Map<String, dynamic> toMap(String category) {
    return {
      'title': title,
      'summary': summary,
      'url': url,
      'category': category,
      'iconName': iconName,
    };
  }


  static const Map<String, IconData> _iconNameMap = {
    'lightbulb_outline': Icons.lightbulb_outline,
    'accessibility_new': Icons.accessibility_new,
    'track_changes': Icons.track_changes,
    'healing': Icons.healing,
    'monitor_heart': Icons.monitor_heart,
    'medical_services': Icons.medical_services,
    'warning_amber': Icons.warning_amber,
    'sentiment_dissatisfied': Icons.sentiment_dissatisfied,
    'sick': Icons.sick,
    'restaurant': Icons.restaurant,
    'food_bank': Icons.food_bank,
    'local_dining': Icons.local_dining,
    'fact_check': Icons.fact_check,
    'question_answer': Icons.question_answer,
    'visibility_off': Icons.visibility_off,
    'spa': Icons.spa,
    'self_improvement': Icons.self_improvement,
    'emoji_emotions': Icons.emoji_emotions,
  };
}

class InsightCard extends StatelessWidget {
  final Insight insight;
  final String category;

  InsightCard({required this.insight, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent.shade100, Colors.purpleAccent.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(
                insight.icon,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                SizedBox(height: 8),
                Text(insight.summary, style: TextStyle(fontSize: 14)),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                        MaterialPageRoute(
                        builder: (context) => WebViewPage(
                      url: insight.url,
                      title: insight.title,
                        ),
                      ),
                    );
                  },
                  child: Text('Read More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

