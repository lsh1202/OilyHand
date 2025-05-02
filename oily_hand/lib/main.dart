import 'package:flutter/material.dart';
import 'package:oily_hand/ui/shock/home_screen.dart';
import 'package:oily_hand/ui/shock/view_model/shock_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShockViewModel()..loadStats(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
