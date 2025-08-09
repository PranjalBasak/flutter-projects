import 'package:flutter/material.dart';
void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner:false, title:"Bad App", home:HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 400];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home")),
        backgroundColor: Colors.amber,
        ),
      body:ListView.builder(
        itemCount: 3,
        itemBuilder: (context, int index){
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: Center(child: Text("Entry ${entries[index]}")),
          );

      })
    );
  }
}