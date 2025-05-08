import 'package:flutter/material.dart';
import 'package:periodtime/webview_page.dart';

class InsightsPage extends StatelessWidget {
  final Map<String, List<Insight>> categorizedInsights = {
  'Overview':[
    Insight(
      title: 'Understanding Your Menstrual Cycle',
      summary: 'Learn about the four phases of your menstrual cycle and how they affect your body and mood.',
      url: 'https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle?utm_source=chatgpt.com',
      imageUrl: 'https://images.unsplash.com/photo-1516585427167-9f4af9627e6c',
    ),
  ],
   /* 'Health': [
      Insight(
        title: '',
        summary: '',
        url: '',
        imageUrl: '',
      ),
    ],
    'Symptoms': [
      Insight(
        title: '',
        summary: '',
        url: '',
        imageUrl: '',
      ),
    ],
    'Nutrition':[
      Insight(
          title: '',
          summary: '',
          url: '',
          imageUrl: '')
    ],
    'Myths':[
      Insight(
          title: '',
          summary: '',
          url: '',
          imageUrl: '')
    ],
    'Self-care':[
      Insight(
          title: '',
          summary: '',
          url: '',
          imageUrl: '')
    ],*/
};

  @override
  Widget build(BuildContext context) {
    final tabs = categorizedInsights.keys.toList();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Period Insights'),
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
                return InsightCard(insight: insights[index]);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Insight{
  final String title;
  final String summary;
  final String url;
  final String imageUrl;

  Insight({required this.title, required this.summary, required this.url, required this.imageUrl});
}


class InsightCard extends StatelessWidget {
  final Insight insight;

  InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(insight.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 180),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

