import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InsightsPage extends StatelessWidget {
  final Map<String, List<Insight>> categorizedInsights = {
  'Knowledge':[
    Insight(
      title: '',
      summary: '',
      url: '',
    ),
  ],
    'Tips & Advice': [
      Insight(
        title: '',
        summary: '',
        url: '',
      ),
    ],
    'FAQ': [
      Insight(
        title: '',
        summary: '',
        url: '',
      ),
    ],
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
  
  Insight({required this.title, required this.summary, required this.url});
}


class InsightCard extends StatelessWidget {
  final Insight insight;

  InsightCard({required this.insight});

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(insight.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${insight.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: ListTile(
        title: Text(insight.title),
        subtitle: Text(insight.summary),
        trailing: Icon(Icons.open_in_new),
        onTap: _launchURL,
      ),
    );
  }
}

