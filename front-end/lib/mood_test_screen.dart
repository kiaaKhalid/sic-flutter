import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/health/mood_declaration_screen.dart';

void main() {
  runApp(const MoodTestApp());
}

class MoodTestApp extends StatelessWidget {
  const MoodTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Humeur',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const Scaffold(
        body: MoodDeclarationScreen(),
      ),
    );
  }
}
