import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MoodEntry {
  final String id;
  final String mood;
  final DateTime date;
  final String notes;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.date,
    required this.notes,
  });

  MoodEntry.fromJson(this.id, Map<String, dynamic> json)
      : mood = json['mood'],
        date = DateTime.parse(json['date']),
        notes = json['notes'];

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}

class MoodTrackingScreen extends StatefulWidget {
  @override
  _MoodTrackingScreenState createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  List<String> moods = ['Happy', 'Sad', 'Angry', 'Excited', 'Anxious'];
  String selectedMood = 'Happy'; // Set a default mood

  TextEditingController _notesController = TextEditingController();
  List<MoodEntry> moodEntries = [];

  @override
  void initState() {
    super.initState();
    fetchMoodEntries();
  }

  void fetchMoodEntries() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final databaseRef = FirebaseDatabase.instance.reference();
      databaseRef.child('moodEntries').child(user.uid).onChildAdded.listen((event) {
        final moodEntryData = event.snapshot.value as Map<dynamic, dynamic>;
        final moodEntry = MoodEntry.fromJson(event.snapshot.key as String, moodEntryData.cast<String, dynamic>());

        setState(() {
          moodEntries.add(moodEntry);
        });
      });
    }
  }

  void _logMood() {
    final moodEntry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: selectedMood,
      date: DateTime.now(),
      notes: _notesController.text,
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final databaseRef = FirebaseDatabase.instance.reference();
      databaseRef.child('moodEntries').child(user.uid).child(moodEntry.id).set(moodEntry.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mood logged successfully')),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(
          'Select your mood:',
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          value: selectedMood,
          items: moods.map((mood) {
            return DropdownMenuItem<String>(
              value: mood,
              child: Text(mood),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMood = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Mood',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Optional Notes',
            border: OutlineInputBorder(),
          ),
        ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: _logMood,
              child: Text('Log Mood'),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Mood Entries:',
            style: TextStyle(fontSize: 18.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: moodEntries.length,
              itemBuilder: (context, index) {
                final moodEntry = moodEntries[index];
                return ListTile(
                  title: Text(moodEntry.mood),
                  subtitle: Text(moodEntry.date.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        final databaseRef = FirebaseDatabase.instance.reference();
                        databaseRef
                            .child('moodEntries')
                            .child(user.uid)
                            .child(moodEntry.id)
                            .remove();
                      }
                    },
                  ),
                );
              },
            ),
          ),
          ],
        ),
      ),
    );
  }
}