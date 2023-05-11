import 'package:flutter/material.dart';
import 'package:mentalwellnessapp/screens/goals_screen.dart';
import 'package:mentalwellnessapp/screens/mood_tracker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Home'),
            Tab(text: 'Mood'),
            Tab(text: 'Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home Tab Content
          Container(
            child: Center(
              child: Text('Home Tab Content'),
            ),
          ),
          // Mood Tab Content
          MoodTrackingScreen(),
          GoalsScreen(),
        ],
      ),
    );
  }
}


