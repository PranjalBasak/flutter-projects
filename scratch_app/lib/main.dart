import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,title: "Bad App", home:HomePage());
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String buffer = "";
  Map<int, int> changeMap = {};

  void handleKeypad(key){
    setState(() {
      if(key == "CLR"){
        buffer="";
        changeMap = {};
      } else if(buffer.length < 8){
          if(buffer=="" && key=="0") return;
          if(key.isEmpty) return;
          buffer += key;
          int amount = int.tryParse(buffer) ?? 0;
          int remaining = amount;
          List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];
          for(var note in notes){
            int count = remaining ~/ note;
            changeMap[note] = count;
            remaining %= note;
          }

      }
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home Page")), backgroundColor: Colors.amber,),
      body: Column(
        
        children:[
          
          // Top Display
          Container(
            alignment: Alignment.center,
            color: Colors.green[100],
            child: ColumnWidgetTopDisplay(buffer: buffer,),   
          ),

          // The Big Pane
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: ColumnWidgetChangeBreakdown(changeMap: changeMap,),
                  ),
                ),

                // SizedBox(width: 16),

                Expanded(
                  flex: 3,
                  child: 
                    KeyPad(onKeyPressed: handleKeypad,),
                      )
            ],),
          ),

      ],
      )
    );
  }
}

class KeyPad extends StatelessWidget {
  List<String> keylist = [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9",
    "0", "", "CLR"
  ];
  final Function(String) onKeyPressed; // callback

  KeyPad({super.key, required this.onKeyPressed});

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Card(
        child: GridView.count(
          crossAxisCount: 3,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 3,
          children: keylist.map((key){
            return ElevatedButton(onPressed: ()=>onKeyPressed(key), child: Text(key));
          }).toList(),
          ),
      ),
    );
  }
}


class ColumnWidgetChangeBreakdown extends StatelessWidget {
  final Map<int,int> changeMap;
  ColumnWidgetChangeBreakdown({
    super.key, required this.changeMap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Text("Change Breakdown:", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height:50),
      OriginalDisplay(changeMap: changeMap,),
    ],);
  }
}

class OriginalDisplay extends StatelessWidget {
  final Map<int,int> changeMap;
  OriginalDisplay({super.key, required this.changeMap});

  Widget buildTile(e){
    return Container(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${e.key}"),
          ),
          Text(":"),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${e.value}"),
          ),
        ]
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final items = changeMap.entries.where((e)=>e.value>0).map((e)=>buildTile(e)).toList();
    if(changeMap.isEmpty){
      return Expanded(
        child: Text("Enter amount to display:"));
    } else{
        return GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: items,
          );
    }
  }
}

class ColumnWidgetTopDisplay extends StatelessWidget {
  final String buffer;
  const ColumnWidgetTopDisplay({
    super.key, required this.buffer
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Taka", style: TextStyle(color: Colors.green[600])),
      Text("\$${this.buffer=="" ? "0" : this.buffer}", style: TextStyle(color: Colors.green[600])),
      ],);
  }
}