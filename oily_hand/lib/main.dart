import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oily_hand/ui/core/themes/theme.dart';
import 'package:oily_hand/ui/core/ui/record_cell.dart';
import 'package:oily_hand/ui/home/home_screen.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    const platform = MethodChannel('com.example.oilyHand/shock');
    await platform.invokeMethod('startShockDetection');
    return Future.value(true);
  });
}

const _shockChannel = MethodChannel('com.example.oilyHand/shock');

Future<void> startShockDetection() async {
  await _shockChannel.invokeMethod('startShockDetection');
}

Future<int> getShockCount() async {
  final count = await _shockChannel.invokeMethod('getShockCount');
  return count as int;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "shockTask",
    "shockDetection",
    frequency: const Duration(minutes: 15),
  );
  runApp(MaterialApp(theme: OHTheme, home: HomeScreen()));
}
