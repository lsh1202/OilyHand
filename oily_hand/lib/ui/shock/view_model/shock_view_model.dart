import 'package:flutter/material.dart';
import '../../../services/shock_service.dart';

class ShockViewModel extends ChangeNotifier {
  final ShockService _service = ShockService();

  int totalShocks = 0;
  double maxShock = 0;
  Map<String, int> last7Days = {}; // ✅ Map 형태로 유지

  Future<void> loadStats() async {
    final stats = await _service.getStats();
    totalShocks = stats["total"] ?? 0;
    maxShock = (stats["max"] ?? 0).toDouble();
    last7Days = Map<String, int>.from(stats["last7Days"] ?? {});
    notifyListeners();
  }

  String get shockComment {
    if (totalShocks == 0) {
      return "완벽해요!!!";
    } else if (totalShocks <= 3) {
      return "이정도면 양호해요!";
    } else if (totalShocks <= 6) {
      return "주의가 필요해요.";
    } else if (totalShocks <= 9) {
      return "물건을 소중히 다뤄요..";
    } else {
      return "기름손 인가요?";
    }
  }
}
