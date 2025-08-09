import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Screen"),),
      body: Center(
        child: Column(
          children: [
            Text(
              "Dobtro Pozhalobhat, $username!",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text("Go  Back"))
          ],
        ),
      ),
    );
  }
}