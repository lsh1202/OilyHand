import 'package:flutter/services.dart';

class ShockService {
  static const MethodChannel _channel = MethodChannel('com.example.oilyHand');

  Future<void> start() async {
    await _channel.invokeMethod('startShockDetection');
  }

  Future<Map<String, dynamic>> getStats() async {
    final result = await _channel.invokeMethod('getShockStats');
    return Map<String, dynamic>.from(result);
  }
}
