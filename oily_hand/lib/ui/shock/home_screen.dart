import 'package:flutter/material.dart';
import 'package:oily_hand/ui/core/themes/style.dart';
import 'package:oily_hand/ui/core/ui/record_cell.dart';
import 'package:oily_hand/ui/shock/view_model/shock_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShockViewModel()..loadStats(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<ShockViewModel>(
          builder: (context, vm, child) {
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "오늘 폰을 몇 번 떨어뜨렸나요?",
                      style: OHTextStyles.common.copyWith(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${vm.totalShocks}회",
                      style: OHTextStyles.common.copyWith(fontSize: 90),
                    ),
                    Text(vm.shockComment, style: OHTextStyles.common),
                    const SizedBox(height: 80),
                    Text(
                      "개인 최고 기록",
                      style: OHTextStyles.common.copyWith(fontSize: 25),
                    ),
                    const Text("🏆", style: TextStyle(fontSize: 70)),
                    Text(
                      "${vm.maxShock.toInt()}회",
                      style: OHTextStyles.common.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: 100),
                    Text(
                      "지난 7일간의 기록",
                      style: OHTextStyles.common.copyWith(fontSize: 25),
                    ),
                    ...vm.last7Days.entries
                        .map(
                          (entry) => RecordCell(
                            date: entry.key,
                            count: entry.value.toString(),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
