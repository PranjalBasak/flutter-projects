import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, title: "Bad App", home: HomePage(),);
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String num_1 = "";
  String num_2 = "";
  String opKey= "";
  int result = 0;
  final List keys = [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9",
    "+", "0", "=",
    "-", "*", "/",
    "X"
  ];

  void handleKeyPress(String key) {
  setState(() {
    if (_isDigit(key)) {
      _appendDigit(key);
    } else if (_isOperator(key)) {
      opKey = key;
    } else if (key == "=") {
      _calculateResult();
    } else if (key == "X") {
      _clear();
    }
  });
}

  bool _isDigit(String key) => RegExp(r'^[0-9]$').hasMatch(key);
  bool _isOperator(String key) => ["+", "-", "*", "/"].contains(key);

  void _appendDigit(String key) {
    if (opKey.isEmpty) {
      num_1 += key;
      result = int.parse(num_1);
    } else {
      num_2 += key;
      result = int.parse(num_2);
    }
  }

  void _calculateResult() {
    if (num_1.isEmpty || num_2.isEmpty || opKey.isEmpty) return;

    final n1 = int.parse(num_1);
    final n2 = int.parse(num_2);

    switch (opKey) {
      case "+":
        result = n1 + n2;
        break;
      case "-":
        result = n1 - n2;
        break;
      case "*":
        result = n1 * n2;
        break;
      case "/":
        result = n2 != 0 ? n1 ~/ n2 : 0; // ~/ for integer division
        break;
    }
  }

  void _clear() {
    num_1 = "";
    num_2 = "";
    opKey = "";
    result = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), backgroundColor: Colors.amber,),
      body: Column(
        children: [

          // Keypad
          Expanded(
            flex: 3,
            child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            // height: constraints.maxHeight * 0.5,
            // width:  constraints.maxWidth * 0.5,
            color: Colors.blueAccent,
            // alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 40,
              children: keys
                .map((key) => ElevatedButton(
                  onPressed: ()=>handleKeyPress(key), 
                  child: Text(key),
                    ),)
                  .toList(),),
                        ),
          ),

          // Display

      
          Expanded(
            flex: 1,
            child: Text("Entered Key: ${result.toString()}")
            ),


        ],
      ),
    );
  }
}