import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_fellows_run/screens/home.dart';
import 'screens/login.dart';
import 'theme/app_theme.dart';

class TheFellowsRun extends StatelessWidget{
  const TheFellowsRun ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "The Fellows Run",
      theme: AppTheme.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}