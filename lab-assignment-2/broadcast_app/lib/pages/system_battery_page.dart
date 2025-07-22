import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';


class SystemBatteryInfoPage extends StatefulWidget {
  const SystemBatteryInfoPage({super.key});

  @override
  State<SystemBatteryInfoPage> createState() => _SystemBatteryInfoPageState();
}

class _SystemBatteryInfoPageState extends State<SystemBatteryInfoPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    // Poll battery level every 100ms seconds
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = level;
      });
    } catch (e) {
      // In case of an error, show -1
      setState(() {
        _batteryLevel = -1;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Battery Info Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Center(
        child: Text(
          _batteryLevel >= 0
              ? 'Battery Level: $_batteryLevel%'
              : 'Error retrieving battery level',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}