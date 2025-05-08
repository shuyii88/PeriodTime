import 'package:flutter/material.dart';
import 'package:periodtime/webview_page.dart';

class InsightsPage extends StatelessWidget {
  final Map<String, List<Insight>> categorizedInsights = {
  'Overview':[
    Insight(
      title: 'Understanding Your Menstrual Cycle',
      summary: 'Discover the four phases of the menstrual cycle (menstruation, follicular, ovulation, luteal), the key hormones involved (estrogen, progesterone, FSH, LH), and their effects on your body and mood.',
      url: 'https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle',
      icon: Icons.lightbulb_outline,
    ),
    Insight(
      title: 'Menstrual Cycle: What is Normal, What is Not',
      summary: 'Learn about the typical length, flow, and symptoms of a normal menstrual cycle, and understand which changes or irregularities might indicate a health issue requiring medical attention.',
      url: 'https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/menstrual-cycle/art-20047186',
      icon: Icons.accessibility_new,
    ),
    Insight(
      title: 'Benefits of tracking your period',
      summary: 'Understand how tracking your menstrual cycle can help you identify patterns, predict ovulation for family planning, detect irregularities that could signal health problems, and better understand your overall health.',
      url: 'https://hsph.harvard.edu/research/apple-womens-health-study/study-updates/benefits-of-tracking-your-period/',
      icon: Icons.track_changes,
    ),
  ],
    'Health': [
      Insight(
        title: 'What Your Period Says About Your Health',
        summary: 'Explore how characteristics of your menstrual cycle, such as cycle length, flow, and pain levels, can provide clues about underlying health conditions like anemia, hormonal imbalances, and other reproductive health issues.',
        url: 'https://www.webmd.com/women/ss/slideshow-period-related-to-health',
        icon: Icons.healing,
      ),
      Insight(
        title: 'How chronic illness can impact your menstrual cycle',
        summary: 'Learn how various chronic illnesses, including thyroid disorders, diabetes, and autoimmune diseases, can affect the regularity, duration, and symptoms of your menstrual cycle, and when to seek medical advice.',
        url: 'https://naturalwomanhood.org/chronic-illness-impacts-menstrual-cycle/',
        icon: Icons.monitor_heart,
      ),
      Insight(
        title: 'Menstrual Cycles as a Fifth Vital Sign',
        summary: 'Discover why healthcare professionals are increasingly recognizing the menstrual cycle as a key indicator of overall health, similar to blood pressure, heart rate, temperature, and respiratory rate, for women of reproductive age.',
        url: 'https://www.nichd.nih.gov/about/org/od/directors_corner/prev_updates/menstrual-cycles',
        icon: Icons.medical_services,
      ),
    ],
    'Symptoms': [
      Insight(
        title: 'PMS (premenstrual syndrome)',
        summary: 'Understand the range of physical and emotional symptoms associated with PMS that occur in the days or weeks leading up to menstruation, and learn about potential management and relief strategies.',
        url: 'https://www.nhs.uk/conditions/pre-menstrual-syndrome/',
        icon: Icons.warning_amber,
      ),
      Insight(
        title: 'PMS vs. PMDD: What\'s the Difference and Which is Worse?',
        summary: 'Distinguish between the more common and milder symptoms of PMS and the severe, often debilitating mood and physical symptoms of Premenstrual Dysphoric Disorder (PMDD), which requires clinical diagnosis and treatment',
        url: 'https://www.webmd.com/women/pms/pms-vs-pmdd',
        icon: Icons.sentiment_dissatisfied,
      ),
      Insight(
        title: 'Regular period pain vs endometriosis',
        summary: 'Learn to differentiate between typical menstrual cramps (dysmenorrhea) and the potentially severe pain associated with endometriosis, a condition where tissue similar to the uterine lining grows outside the uterus, and understand when medical evaluation is necessary.',
        url: 'https://www.topdoctors.co.uk/medical-articles/know-difference-between-regular-period-pain-endometriosis?__cf_chl_tk=JQtQQubozrgkMRAdAUNeU4FiiIgCxDAJrABvo8f4yWQ-1746692475-1.0.1.1-e5H82IqA8UPWH3rSgtPc4XUTBjbJTLr4P3D93su97Dw',
        icon: Icons.sick,
      ),
    ],
    'Nutrition':[
      Insight(
        title: 'Foods That Help Reduce Period Symptoms',
        summary: 'Discover specific foods and nutrients, such as omega-3 fatty acids, calcium, magnesium, and fiber, that may help alleviate common menstrual symptoms like cramps, bloating, and fatigue.',
        url: 'https://www.healthline.com/health/womens-health/what-to-eat-during-period',
        icon: Icons.restaurant,
      ),
      Insight(
        title: 'Eating for Your Cycle: Phase-Based Nutrition',
        summary: 'Explore the concept of cycle syncing, which involves adjusting your diet to support the hormonal shifts and energy needs of each phase of your menstrual cycle (follicular, ovulation, luteal, menstruation).',
        url: 'https://elara.care/nutrition/menstrual-cycle-food-chart/',
        icon: Icons.food_bank,
      ),
      Insight(
        title: '14 Iron-Rich Foods to Fight Off Fatigue',
        summary: 'Learn about various food sources rich in iron, an essential mineral that can help replenish iron levels lost during menstruation and combat associated fatigue and weakness.',
        url: 'https://www.vogue.com/article/best-iron-rich-food',
        icon: Icons.local_dining,
      ),
    ],
    'Myths':[
      Insight(
        title: 'Eight myths about periods',
        summary: 'Uncover and debunk common misconceptions surrounding menstruation, addressing misinformation related to hygiene, activities, and general beliefs about periods.',
        url: 'https://www.unicef.org.au/stories/busted-eight-myths-about-periods',
        icon: Icons.fact_check,
      ),
      Insight(
        title: 'Debunking Common Myths About Tampons',
        summary: 'Address and clarify prevalent myths and anxieties associated with tampon use, providing factual information about their safety and proper usage.',
        url: 'https://health.clevelandclinic.org/common-misconceptions-about-tampons',
        icon: Icons.question_answer,
      ),
      Insight(
        title: 'Cultural Period Taboos and Their Impact',
        summary: 'Examine the origins and consequences of various cultural taboos and negative beliefs surrounding menstruation, and their effects on women\'s health, education, and social well-being.',
        url: 'https://www.onlymyhealth.com/impact-of-menstrual-taboos-on-womens-health-and-wellbeing-1684923914',
        icon: Icons.visibility_off,
      ),
    ],
    'Self-care':[
      Insight(
        title: 'Period self-care',
        summary: 'Discover a range of self-care practices, including rest, heat therapy, gentle movement, and mindful activities, that can help alleviate physical discomfort and improve emotional well-being during menstruation.',
        url: 'https://bloodybrilliant.wales/my-period/period-self-care/',
        icon: Icons.spa,
      ),
      Insight(
        title: 'Exercise and Your Period: What Works Best',
        summary: 'Explore how different types of exercise, from gentle walking and yoga to more intense activities, can impact menstrual symptoms and overall well-being during different phases of your cycle.',
        url: 'https://flo.health/menstrual-cycle/lifestyle/fitness-and-exercise/exercising-during-period',
        icon: Icons.self_improvement,
      ),
      Insight(
        title: 'Mental Health and the Menstrual Cycle: Understanding the Impact',
        summary: 'Learn about the connection between hormonal fluctuations during the menstrual cycle and mental health, including increased susceptibility to mood swings, anxiety, and depression, and explore coping strategies.',
        url: 'https://www.manchestermind.org/menstrual-cycle/',
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
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Period Insights'),
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

