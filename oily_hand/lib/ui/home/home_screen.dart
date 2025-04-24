import 'package:flutter/material.dart';
import 'package:oily_hand/services/shock_service.dart';
import 'package:oily_hand/ui/core/ui/record_cell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int todayCount = 0;
  int maxRecord = 0;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadShockData();
    ShockService.startShockDetection(); // 앱 시작 시 감지도 시작
  }

  Future<void> loadShockData() async {
    final stats = await ShockService.getShockStats();
    setState(() {
      todayCount = stats['today'] ?? 0;
      maxRecord = stats['max'] ?? 0;
      history = List<Map<String, dynamic>>.from(stats['history'] ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(
                "오늘 감지 횟수: $todayCount",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "최고 기록: $maxRecord",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                "날짜별 감지 히스토리",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return RecordCell(date: item["date"], count: item["count"]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
