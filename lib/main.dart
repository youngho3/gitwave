import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GitWaveApp());
}

class GitWaveApp extends StatelessWidget {
  const GitWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitWave',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
