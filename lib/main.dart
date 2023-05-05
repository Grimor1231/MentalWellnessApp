import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentalwellnessapp/screens/welcome_screen.dart';
import 'package:mentalwellnessapp/screens/sign_up_screen.dart';
import 'package:mentalwellnessapp/screens/sign_in_screen.dart';
import 'package:mentalwellnessapp/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Mental Wellness App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: WelcomeScreen(),
            routes: {
              '/signup': (context) => SignUpScreen(),
              '/signin': (context) => SignInScreen(),
              '/main': (context) => MainScreen(),
              // ... (other routes)
            },
          );
        }

        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Something went wrong')),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}


