import 'package:flutter/material.dart';

void main() {
  runApp(VangtiChaiApp()); // Call our custom app widget VangtiChaiApp
}

class VangtiChaiApp extends StatelessWidget {
  // Stateless because the app-level config (theme, routes, etc.) won’t change.
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VangtiChai(),
    );
  }
}

class VangtiChai extends StatefulWidget {
  // Why stateful?

  // Needs to update UI whenever:

  // User enters digits

  // User hits CLR

  // Change calculation result updates
  const VangtiChai({super.key});

  @override
  State<VangtiChai> createState() => _VangtiChaiState();
}

class _VangtiChaiState extends State<VangtiChai> {
  String amountStr = "";
  Map<int, int> changeMap = {};

    //   State Variables

    // String amountStr = "";
    // Map<int, int> changeMap = {};
    // amountStr → what user has typed, e.g. "873".

    // changeMap → the denomination breakdown:

    // {
    //   500: 1,
    //   100: 3,
    //   ...
    // }

  void onDigitPressed(String digit) {
    setState(() { // In Flutter, setState() is a method used to update the user interface (UI) 
                  // when the state of a StatefulWidget changes. Calling setState() tells Flutter
                  // to rebuild the widget and its subtree with the updated data, ensuring the UI 
                  // reflects the current state
      // Prevent entering amounts larger than reasonable limit
      if (amountStr.length < 8) {
        amountStr += digit;
        calculate();
      }
    });
  }

  void onClear() {
    setState(() {
      amountStr = "";
      changeMap.clear();
    });
  }

  void calculate() {
    int amount = int.tryParse(amountStr) ?? 0;
    changeMap = calculateChange(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VangtiChai"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          BuildAmountDisplay(amountStr: amountStr,),
          Expanded(child: buildPortrait()),
        ],
      ), // For simplicity, using portrait layout only
    );
  }

  Widget buildPortrait() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          
          // Calculate responsive breakpoints based on screen size
          bool isVeryNarrow = screenWidth < 500;
          bool isNarrow = screenWidth < 700;
          bool isMedium = screenWidth < 900;
          
          // Calculate optimal keypad dimensions that fit side-by-side
          double availableWidthForKeypad = (screenWidth - 32 - 16) * 0.35; // Account for padding and spacing
          double keypadWidth = availableWidthForKeypad.clamp(150.0, 280.0);
          
          // Adjust flex ratios based on screen size for better proportions - give keypad more space
          int changeTableFlex = isVeryNarrow ? 2 : (isNarrow ? 3 : (isMedium ? 4 : 5));
          int keypadFlex = isVeryNarrow ? 3 : (isNarrow ? 4 : (isMedium ? 5 : 6));
          
          return Row(
            children: [
              Expanded(
                flex: changeTableFlex,
                child: buildChangeTable(),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: keypadFlex,
                child: Center(
                  child: SizedBox(
                    width: keypadWidth,
                    child: buildKeypad(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildLandscape() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(flex: 2, child: buildChangeTable()),
          SizedBox(height: 16),
          Expanded(flex: 3, child: buildKeypad()),
        ],
      ),
    );
  }

  Widget buildChangeTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        
        // Scale down text and padding for smaller screens - more aggressive scaling
        double titleFontSize = availableWidth < 250 ? 10.0 : (availableWidth < 350 ? 12.0 : (availableWidth < 450 ? 14.0 : 18.0));
        double itemFontSize = availableWidth < 250 ? 8.0 : (availableWidth < 350 ? 10.0 : (availableWidth < 450 ? 12.0 : 16.0));
        double padding = availableWidth < 250 ? 4.0 : (availableWidth < 350 ? 6.0 : (availableWidth < 450 ? 8.0 : 16.0));
        double itemPadding = availableWidth < 250 ? 3.0 : (availableWidth < 350 ? 4.0 : (availableWidth < 450 ? 6.0 : 12.0));
        double badgePadding = availableWidth < 250 ? 3.0 : (availableWidth < 350 ? 4.0 : (availableWidth < 450 ? 6.0 : 12.0));
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Change breakdown
                Text(
                  "Change Breakdown:",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                
                Expanded(
                  child: changeMap.isEmpty 
                    ? Center(
                        child: Text(
                          "Enter amount to see change",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: itemFontSize,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: changeMap.entries
                              .where((e) => e.value > 0)
                              .map((e) => Container(
                                margin: EdgeInsets.symmetric(vertical: availableWidth < 250 ? 1.0 : (availableWidth < 350 ? 1.5 : 2.0)),
                                padding: EdgeInsets.all(itemPadding),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(availableWidth < 250 ? 3.0 : (availableWidth < 350 ? 4.0 : 6.0)),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "৳${e.key}",
                                      style: TextStyle(
                                        fontSize: itemFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: badgePadding,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(availableWidth < 250 ? 6.0 : (availableWidth < 350 ? 8.0 : 12.0)),
                                      ),
                                      child: Text(
                                        "${e.value}",
                                        style: TextStyle(
                                          fontSize: itemFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                              .toList(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildKeypad() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        
        // Scale down spacing and padding for smaller screens
        double padding = availableWidth < 200 ? 6.0 : (availableWidth < 300 ? 8.0 : (availableWidth < 400 ? 12.0 : 16.0));
        double spacing = availableWidth < 200 ? 4.0 : (availableWidth < 300 ? 6.0 : (availableWidth < 400 ? 8.0 : 12.0));
        double fontSize = availableWidth < 200 ? 14.0 : (availableWidth < 300 ? 16.0 : (availableWidth < 400 ? 18.0 : 20.0));
        double borderRadius = availableWidth < 200 ? 6.0 : (availableWidth < 300 ? 8.0 : (availableWidth < 400 ? 10.0 : 12.0));
        
        List<String> keys = [
          "1", "2", "3",
          "4", "5", "6", 
          "7", "8", "9",
          "0", "", "CLR"
        ];

        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              children: keys.map((key) {
                if (key.isEmpty) {
                  return SizedBox();
                }
                
                bool isClear = key == "CLR";
                
                return ElevatedButton(
                  onPressed: () {
                    if (isClear) {
                      onClear();
                    } else {
                      onDigitPressed(key);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isClear ? Colors.red[400] : Colors.green[600],
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(key),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}


  

class BuildAmountDisplay extends StatelessWidget {
  const BuildAmountDisplay({
    super.key,
    required this.amountStr,
  });

  final String amountStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "৳${amountStr.isEmpty ? '0' : amountStr}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }
}

Map<int, int> calculateChange(int amount) {
  List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];
  Map<int, int> result = {};
  int remaining = amount;
  
  for (var note in notes) {
    int count = remaining ~/ note;
    result[note] = count;
    remaining %= note;
  }
  
  return result;
}