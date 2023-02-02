import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample_project_1/pages/home_page.dart';
import 'package:sample_project_1/pages/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
