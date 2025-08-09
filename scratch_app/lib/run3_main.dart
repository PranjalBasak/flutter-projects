import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: "Bad Title", home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _listWidget = List.generate(11, (index)=>Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bad App"), backgroundColor: Colors.amber,),
      body: Center(
        child: Card(
          color: Colors.amber,
          child: SizedBox(
            height: 500,
            width: 500,
            child: GridView.count(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 4,
                childAspectRatio: 1,
                padding: EdgeInsets.all(20),
                children: 
                // [
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                //   Container(alignment: Alignment.center, child: Text("Hello World"), color: Colors.blue,),
                // ]
                _listWidget
              ),
          ),
        ),
      ),
      );
  }
}