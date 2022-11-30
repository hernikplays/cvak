import 'package:cvak/okna/domu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cvak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DomovskaObrazovka(),
    );
  }
}
