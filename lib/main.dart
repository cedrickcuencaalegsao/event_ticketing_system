import 'package:flutter/material.dart';
import 'package:event_ticketing_system/app/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ticketing',
      home: const App(),
    );
  }
}
