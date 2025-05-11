import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'pages/home_page.dart';

void main() => runApp(const PomodoroApp());

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Timer',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _splashDone = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _splashDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _splashDone ? HomePage() : const SplashScreen();
  }
}