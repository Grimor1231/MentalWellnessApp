// goals_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController();

  // This list will hold the user's goals
  List<String> goals = [];

  void _addGoal() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        goals.add(_goalController.text);
        _goalController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _goalController,
                decoration: InputDecoration(labelText: 'Goal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal.';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addGoal,
              child: Text('Add Goal'),
            ),
            SizedBox(height: 16.0),
            Text(
              'My Goals:',
              style: TextStyle(fontSize: 18.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(goals[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          goals.removeAt(index);
                        });
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

