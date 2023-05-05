import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // This would be a placeholder for app logo, consider replacing it with Image widget
            Container(
              child: Icon(
                Icons.health_and_safety,
                size: 100,
              ),
            ),
            Text(
              'Mental Wellness App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50), // provide some spacing
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),

            SizedBox(height: 20), // provide some spacing
            TextButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
    );
  }
}