import 'package:flutter/material.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _shockCount = 0;

  @override
  void initState() {
    super.initState();
    startShockDetection();
  }

  Future<void> loadShockCount() async {
    final count = await getShockCount();
    setState(() {
      _shockCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "오늘 폰을 몇 번 떨어뜨렸나요?",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Pretendard",
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
