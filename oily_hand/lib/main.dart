import 'package:flutter/material.dart';
import 'package:oily_hand/ui/core/themes/theme.dart';
import 'package:oily_hand/ui/core/ui/record_cell.dart';

void main() {
  runApp(
    MaterialApp(
      theme: OHTheme,
      home: Scaffold(
        body: Center(child: RecordCell(date: "2025.04.01", count: "7")),
      ),
    ),
  );
}
