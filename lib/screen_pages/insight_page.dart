import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periodtime/screen_pages/webview_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({Key? key}) : super(key: key);

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

enum SortOption {
  none,
  mostViewed,
  mostLiked
}

class _InsightsPageState extends State<InsightsPage> {
  late Future<Map<String, List<Insight>>> _futureInsights;
  SortOption _currentSortOption = SortOption.none;

  @override
  void initState() {
    super.initState();
    _futureInsights = fetchInsightsFromFirestore();
  }

  Future<Map<String, List<Insight>>> fetchInsightsFromFirestore() async {
    Query query = FirebaseFirestore.instance.collection('insights');

    switch (_currentSortOption) {
      case SortOption.mostViewed:
        query = query.orderBy('view', descending: true);
        break;
      case SortOption.mostLiked:
        query = query.orderBy('like', descending: true);
        break;
      case SortOption.none:
        break;
    }

    final snapshot = await query.get();
    Map<String, List<Insight>> categorized = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final category = data['category'] ?? 'Other';

      final insight = Insight(
        docId: doc.id,
        title: data['title'] ?? '',
        summary: data['summary'] ?? '',
        url: data['url'] ?? '',
        icon: Insight.getIconFromName(data['iconName'] ?? 'lightbulb_outline'),
        like: data['like'] ?? 0,
        view: data['view'] ?? 0,
      );

      categorized.putIfAbsent(category, () => []).add(insight);
    }

    return categorized;
  }

  void _sortInsights() {
    setState(() {
      switch (_currentSortOption) {
        case SortOption.none:
          _currentSortOption = SortOption.mostViewed;
          break;
        case SortOption.mostViewed:
          _currentSortOption = SortOption.mostLiked;
          break;
        case SortOption.mostLiked:
          _currentSortOption = SortOption.none;
          break;
      }
      _futureInsights = fetchInsightsFromFirestore();
    });
  }

  Map<String, List<Insight>> _applySorting(Map<String, List<Insight>> categorizedInsights) {
    Map<String, List<Insight>> sortedMap = {};

    categorizedInsights.forEach((category, insights) {
      List<Insight> sortedInsights = List.from(insights);

      switch (_currentSortOption) {
        case SortOption.mostViewed:
          sortedInsights.sort((a, b) => b.view.compareTo(a.view));
          break;
        case SortOption.mostLiked:
          sortedInsights.sort((a, b) => b.like.compareTo(a.like));
          break;
        case SortOption.none:
          break;
      }

      sortedMap[category] = sortedInsights;
    });

    return sortedMap;
  }

  String _getSortButtonText() {
    switch (_currentSortOption) {
      case SortOption.none:
        return 'Sort';
      case SortOption.mostViewed:
        return 'Sort by Views';
      case SortOption.mostLiked:
        return 'Sort by Likes';
    }
  }

  IconData _getSortButtonIcon() {
    switch (_currentSortOption) {
      case SortOption.none:
        return Icons.sort;
      case SortOption.mostViewed:
        return Icons.visibility;
      case SortOption.mostLiked:
        return Icons.thumb_up;
    }
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
          final categorizedInsights = _applySorting(snapshot.data!);
          final tabs = categorizedInsights.keys.toList()
            ..sort((a, b) {
              if (a == 'Overview') return -1;
              if (b == 'Overview') return 1;
              return a.compareTo(b);
            });

          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: Colors.pink[50],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: Icon(Icons.favorite, color: Colors.black),
                title: Text('Period Insights', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  TextButton.icon(
                    onPressed: _sortInsights,
                    icon: Icon(_getSortButtonIcon(), color: Colors.black),
                    label: Text(_getSortButtonText(),
                        style: TextStyle(color: Colors.black)
                    ),
                  ),
                ],
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
                      return InsightCard(
                        insight: insights[index],
                        category: tab,
                        sortLabel: _getSortLabel(insights[index], index),
                      );
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

  Widget? _getSortLabel(Insight insight, int index) {
    if (_currentSortOption == SortOption.none || index > 0) {
      return null;
    }

    // Only display badge for the top item (index = 0)
    Color badgeColor = Colors.amber;
    String label = "Hot";
    IconData iconData;

    if (_currentSortOption == SortOption.mostViewed) {
      iconData = Icons.visibility;
    } else {
      iconData = Icons.thumb_up;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class Insight {
  final String docId;
  final String title;
  final String summary;
  final String url;
  final IconData icon;
  int like;
  int view;

  Insight(
      {required this.docId, required this.title, required this.summary, required this.url, required this.icon, this.like = 0, this.view = 0});

  Future<void> incrementLike() async {
    FirebaseFirestore.instance.collection('insights').doc(docId).update({
      'like': FieldValue.increment(1),
    });
  }

  Future<void> incrementView() async {
    FirebaseFirestore.instance.collection('insights').doc(docId).update({
      'view': FieldValue.increment(1),
    });
  }

  Future<bool> hasUserLiked() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('insights')
        .doc(docId)
        .collection('likes')
        .doc(uid)
        .get();

    return doc.exists;
  }

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
      'like': like,
      'view': view,
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

class InsightCard extends StatefulWidget {
  final Insight insight;
  final String category;
  final Widget? sortLabel;

  InsightCard({required this.insight, required this.category, this.sortLabel});

  @override
  _InsightCardState createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard> {
  late int like;
  late int view;
  bool hasLiked = false;

  @override
  void initState() {
    super.initState();
    like = widget.insight.like;
    view = widget.insight.view;

    widget.insight.hasUserLiked().then((liked) {
      setState(() {
        hasLiked = liked;
      });
    });
  }

  Future<void> likeOnce() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final insightRef = FirebaseFirestore.instance
        .collection('insights')
        .doc(widget.insight.docId);

    final likeDocRef = insightRef
        .collection('likes')
        .doc(uid);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Check if user has liked
      final likeDoc = await transaction.get(likeDocRef);
      final insightDoc = await transaction.get(insightRef);

      if (!insightDoc.exists) {
        throw Exception('Insight document does not exist!');
      }

      final currentLikes = insightDoc.data()?['like'] ?? 0;

      if (likeDoc.exists) {
        // User has already liked, so unlike
        transaction.delete(likeDocRef);
        transaction.update(insightRef, {'like': currentLikes - 1});

        // Update local state after transaction completes
        setState(() {
          like -= 1;
          hasLiked = false;
        });
      } else {
        // User has not liked, so add like
        transaction.set(likeDocRef, {'likedAt': FieldValue.serverTimestamp()});
        transaction.update(insightRef, {'like': currentLikes + 1});

        // Update local state after transaction completes
        setState(() {
          like += 1;
          hasLiked = true;
        });
      }
    }).catchError((error) {
      print('Transaction failed: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Column(
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
                    widget.insight.icon,
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
                    Text(widget.insight.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                    SizedBox(height: 8),
                    Text(widget.insight.summary, style: TextStyle(fontSize: 14)),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await widget.insight.incrementView();
                        setState(() => view += 1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url: widget.insight.url,
                              title: widget.insight.title,
                            ),
                          ),
                        );
                      },
                      child: Text('Read More'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: likeOnce,
                          icon: Icon(Icons.thumb_up, color: hasLiked ? Colors.red : Colors.black),
                        ),
                        Text('Likes: $like'),
                        Text('Views: $view'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.sortLabel != null)
            Positioned(
              top: 10,
              right: 10,
              child: widget.sortLabel!,
            ),
        ],
      ),
    );
  }
}