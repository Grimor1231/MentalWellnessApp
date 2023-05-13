// lib/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
      ElevatedButton(
      child: Text('Sign In'),
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          try {
            final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: _email!,
              password: _password!,
            );
            if (userCredential.user != null) {
              // Sign-in successful, navigate to the main screen
              Navigator.pushReplacementNamed(context, '/main');
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
            }
          }
        }
      },
    ),


   /* SizedBox(height: 16),
              Text('OR'),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Image.network(
                  'https://www.liblogo.com/img-logo/go490g5ab-google-icon-logo-google-search-new-logo-free-icon-of-google-new-logos.png', // Add the Google logo image asset to your project
                  height: 24,
                ),
                label: Text('Sign In with Google'),
                onPressed: () {
                  // Perform sign in with Google
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
