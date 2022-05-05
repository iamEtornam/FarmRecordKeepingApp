import 'package:farm_keep/ui/home_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmKeep',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: HomeView(),
    );
  }
}
