import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomBroadcastInputPage extends StatefulWidget {
  const CustomBroadcastInputPage({super.key});
  @override
  CustomBroadcastInputPageState createState() => CustomBroadcastInputPageState();
}


class CustomBroadcastInputPageState extends State<CustomBroadcastInputPage> {
  final TextEditingController _textController = TextEditingController();
  final String broadcastName = "de.kevlatus.broadcast";

  final BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );

  @override
  void initState() {
    super.initState();

    receiver.start();
      // Listen to broadcast messages and show toast
    receiver.messages.listen((message) {
      _showToast(message);
    });
  }

  @override
  void dispose() {
    receiver.stop();
    _textController.dispose();
    super.dispose();
  }

  void _showToast(dynamic message) {
    String toastMessage = '';
    
    if (message is BroadcastMessage) {
      // Extract data from BroadcastMessage
      //toastMessage = 'Broadcast: ${message.name}\nData: ${message.data}';
      toastMessage = '${message.data?["user_text"]}';
    } else {
      // Handle other message types
      toastMessage = 'Received: $message';
    }

    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    //drawer: NavigationDrawer(),
    appBar: AppBar(
      title: const Text('Custom Broadcast Receiver'),
      backgroundColor: const Color.fromARGB(255, 57, 126, 216),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a text to broadcast',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String userText = _textController.text.trim();
                sendBroadcast(
                  BroadcastMessage(
                    name: "de.kevlatus.flutter_broadcasts_example.demo_action",
                    data: {
                      "user_text": userText.isNotEmpty ? userText : "default"
                    },
                  )
                );
                _textController.clear();
              },
              child: const Text('Send Broadcast'),
            ),
          ],
        ),
      ),
    ),
  );
}
