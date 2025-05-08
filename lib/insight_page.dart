import 'package:flutter/material.dart';
import 'package:periodtime/webview_page.dart';

class InsightsPage extends StatelessWidget {
  final Map<String, List<Insight>> categorizedInsights = {
  'Overview':[
    Insight(
      title: 'Understanding Your Menstrual Cycle',
      summary: 'Learn about the four phases of your menstrual cycle and how they affect your body and mood.',
      url: 'https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle?utm_source=chatgpt.com',
      icon: Icons.lightbulb_outline,
    ),
    Insight(
      title: 'Menstrual Cycle: What is Normal, What is Not',
      summary: 'Discover what constitutes a normal period and when you should consult with a healthcare provider.',
      url: 'https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/menstrual-cycle/art-20047186',
      icon: Icons.accessibility_new,
    ),
    Insight(
      title: 'Tracking Your Cycle: Why It Matters',
      summary: 'Understand how tracking your cycle can provide valuable insights into your overall health and well-being.',
      url: 'https://www.hopkinsmedicine.org/health/conditions-and-diseases/the-menstrual-cycle',
      icon: Icons.track_changes,
    ),
  ],
    'Health': [
      Insight(
        title: 'How Your Period Reflects Your Health',
        summary: 'Your menstrual cycle can be an indicator of your overall health. Learn what changes might mean.',
        url: 'https://www.healthline.com/health/womens-health/menstrual-cycle-and-health',
        icon: Icons.healing,
      ),
      Insight(
        title: 'Menstruation and Chronic Health Conditions',
        summary: 'How certain health conditions can affect your period and what symptoms deserve medical attention.',
        url: 'https://www.medicalnewstoday.com/articles/periods-and-overall-health',
        icon: Icons.monitor_heart,
      ),
      Insight(
        title: 'Your Cycle as a Vital Sign',
        summary: 'Healthcare providers now consider your menstrual cycle as important as other vital signs for monitoring health.',
        url: 'https://www.acog.org/womens-health/faqs/your-menstrual-cycle',
        icon: Icons.medical_services,
      ),
    ],
    'Symptoms': [
      Insight(
        title: 'Common Period Symptoms and How to Manage Them',
        summary: 'From cramps to mood swings, learn about typical menstrual symptoms and effective relief strategies.',
        url: 'https://www.healthline.com/health/womens-health/menstrual-symptoms',
        icon: Icons.warning_amber,
      ),
      Insight(
        title: 'PMS vs. PMDD: Understanding the Difference',
        summary: 'While many experience PMS, PMDD is more severe. Learn how to identify and address both conditions.',
        url: 'https://www.mayoclinic.org/diseases-conditions/premenstrual-syndrome/symptoms-causes/syc-20376780',
        icon: Icons.sentiment_dissatisfied,
      ),
      Insight(
        title: 'When Period Pain Is not Normal: Signs of Endometriosis',
        summary: 'Severe menstrual pain can indicate underlying conditions. Learn when to seek medical help.',
        url: 'https://www.nichd.nih.gov/health/topics/menstruation/conditioninfo/symptoms',
        icon: Icons.sick,
      ),
    ],
    'Nutrition':[
      Insight(
        title: 'Foods That Help Reduce Period Symptoms',
        summary: 'Discover which nutrients and foods can help alleviate menstrual discomfort and boost energy.',
        url: 'https://www.healthline.com/nutrition/diet-during-period',
        icon: Icons.restaurant,
      ),
      Insight(
        title: 'Eating for Your Cycle: Phase-Based Nutrition',
        summary: 'How to adjust your diet throughout your menstrual cycle to support hormonal changes and feel your best.',
        url: 'https://www.medicalnewstoday.com/articles/foods-to-eat-during-period',
        icon: Icons.food_bank,
      ),
      Insight(
        title: 'Iron-Rich Foods to Combat Period Fatigue',
        summary: 'Menstrual blood loss can lead to iron deficiency. Learn which foods can help maintain your energy levels.',
        url: 'https://www.health.harvard.edu/womens-health/diet-and-menstrual-health',
        icon: Icons.local_dining,
      ),
    ],
    'Myths':[
      Insight(
        title: 'Period Myths: Separating Fact from Fiction',
        summary: 'Debunking common misconceptions about menstruation that have persisted through generations.',
        url: 'https://www.hopkinsmedicine.org/health/wellness-and-prevention/period-myths-busted',
        icon: Icons.fact_check,
      ),
      Insight(
        title: 'No, You Cannot Lose a Tampon Inside You: Busting Hygiene Myths',
        summary: 'Addressing fears and misinformation about menstrual hygiene products and practices.',
        url: 'https://www.plannedparenthood.org/blog/5-period-myths-debunked',
        icon: Icons.question_answer,
      ),
      Insight(
        title: 'Cultural Period Taboos and Their Impact',
        summary: 'How cultural myths and taboos about menstruation affect women\'s health and society\'s attitudes.',
        url: 'https://helloclue.com/articles/cycle-a-z/myths-misconceptions-about-menstruation',
        icon: Icons.visibility_off,
      ),
    ],
    'Self-care':[
      Insight(
        title: 'Creating Your Perfect Period Self-Care Routine',
        summary: 'Simple yet effective self-care practices to incorporate during your menstrual cycle for physical and emotional wellbeing.',
        url: 'https://www.healthline.com/health/womens-health/self-care-during-period',
        icon: Icons.spa,
      ),
      Insight(
        title: 'Exercise and Your Period: What Works Best',
        summary: 'How different types of movement can alleviate symptoms throughout your cycle phases.',
        url: 'https://www.medicalnewstoday.com/articles/period-self-care',
        icon: Icons.self_improvement,
      ),
      Insight(
        title: 'Menstrual Mindfulness: Managing Emotions During Your Cycle',
        summary: 'Techniques for emotional regulation and stress management that are especially helpful during menstruation.',
        url: 'https://www.everydayhealth.com/womens-health/menstrual-self-care-tips/',
        icon: Icons.emoji_emotions,
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
                return InsightCard(insight: insights[index], category: tab,);
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
  final IconData icon;

  Insight({required this.title, required this.summary, required this.url, required this.icon});
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

