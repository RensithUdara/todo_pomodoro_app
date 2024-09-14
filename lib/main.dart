import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Pomodoro App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        cardColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat', // Custom font
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
