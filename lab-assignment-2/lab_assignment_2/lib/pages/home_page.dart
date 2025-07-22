import 'package:flutter/material.dart';
import 'package:broadcast_app/pages/custom_broadcast_page.dart';
import 'package:broadcast_app/pages/system_battery_page.dart';
import 'package:broadcast_app/menu/navigation_drawer.dart' as custom_nav;


class SimpleBroadcastApp extends StatelessWidget {
  const SimpleBroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _count = 0;
  String selectedBroadcastType = 'Custom broadcast receiver';

  final List<String> broadcastTypes = [
    'Custom broadcast receiver',
    'System battery notification receiver'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Receiver'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text("Select a broadcast type",
                style: TextStyle(
                  fontSize: 24, // Set your desired font size here
                ),
                ),
              ),

              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedBroadcastType,
                items: broadcastTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedBroadcastType = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () {
                    if (selectedBroadcastType == 'Custom broadcast receiver') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                            CustomBroadcastInputPage(),
                        ),
                      );
                    } else if (selectedBroadcastType ==
                        'System battery notification receiver') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SystemBatteryInfoPage(),
                        ),
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ),
      ),
      drawer: custom_nav.NavigationDrawer(),
    );
  }
}