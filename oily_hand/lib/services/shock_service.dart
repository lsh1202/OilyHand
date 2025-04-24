import 'package:flutter/services.dart';

class ShockService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.oilyHand/shock',
  );

  static Future<void> startShockDetection() async {
    try {
      await _channel.invokeMethod('startShockDetection');
    } catch (e) {
      print("실패: $e");
    }
  }

  static Future<Map<String, dynamic>> getShockStats() async {
    try {
      final result = await _channel.invokeMethod('getShockStats');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      print("실패: $e");
      return {};
    }
  }
}
