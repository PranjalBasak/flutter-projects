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
          Expanded(child: buildContainer()),
        ],
      ), // For simplicity, using portrait layout only
    );
  }

  // It will Build the UI for the Main Content
  Widget buildContainer() { 
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          //double screenHeight = constraints.maxHeight;
          
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
                child: buildChangeTable(), // Build the change table with responsive design
              ),
              SizedBox(width: 16),
              Expanded(
                flex: keypadFlex,
                child: Center(
                  child: SizedBox(
                    width: keypadWidth,
                    child: buildKeypad(), // Build the keypad with responsive design
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildChangeTile(
  MapEntry<int, int> e,
  double availableWidth,
  double itemFontSize,
  double itemPadding,
  double badgePadding,
) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: availableWidth < 250
          ? 1.0
          : (availableWidth < 350 ? 1.5 : 2.0),
    ),
    padding: EdgeInsets.all(itemPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        availableWidth < 250
            ? 3.0
            : (availableWidth < 350 ? 4.0 : 6.0),
      ),
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
            borderRadius: BorderRadius.circular(
              availableWidth < 250
                  ? 6.0
                  : (availableWidth < 350 ? 8.0 : 12.0),
            ),
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
        
        return Card( // Use Card to give a nice elevation effect
          elevation: 4,
          child: 
          Padding(
            padding: EdgeInsets.all(padding),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                


                Text( // Just "Change Breakdown:" label
                  "Change Breakdown:",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),


                SizedBox(height: 8), // Space between title and items
                

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
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            double screenHeight = constraints.maxHeight;
                            double screenWidth = constraints.maxWidth;
                            //bool isShortScreen = screenHeight < 400;

                            final items = changeMap.entries
                                .where((e) => e.value > 0)
                                .map((e) => buildChangeTile(e, availableWidth, itemFontSize, itemPadding, badgePadding))
                                .toList();

                            // if (!isShortScreen  && screenHeight > screenWidth) {
                            if (screenHeight > screenWidth) {
                              // Normal height → show single column
                              return SingleChildScrollView(
                                child: Column(
                                  children: items,
                                ),
                              );
                            } else {
                              // Short screen → show 2 columns
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 3, // adjust to make items less tall
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: items,
                              );
                            }
                          },
                        ),
                )



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
        double spacing = availableWidth < 200 ? 1.0 : (availableWidth < 300 ? 2.0 : (availableWidth < 400 ? 8.0 : 12.0));
        double fontSize = availableWidth < 200 ? 6.0 : (availableWidth < 300 ? 10.0 : (availableWidth < 400 ? 18.0 : 20.0));
        double borderRadius = availableWidth < 200 ? 6.0 : (availableWidth < 300 ? 8.0 : (availableWidth < 400 ? 10.0 : 12.0));
        


        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        //bool isShortScreen = screenHeight < 500; // Check if the screen height is less than 500 pixels to determine if it's a short screen
        bool isLandscape = screenWidth > screenHeight;
        List<String> keys3Columns = [
          "1", "2", "3",
          "4", "5", "6", 
          "7", "8", "9",
          "0", "", "CLR"
        ];

        List<String> keys4Columns = [
          "1", "2", "3", "4",
          "5", "6", "7", "8",
          "9", "", "", "CLR"
        ];

      
        // List<String> keys = (isShortScreen ||  isLandscape)? 
        List<String> keys = isLandscape?
          keys4Columns : // If the screen is short, we will use 4 columns
          keys3Columns; // Otherwise, we will use 3 columns


        return Card( // Use Card to give a nice elevation effect


          elevation: 4,
          child: 
          
          Padding(
            padding: EdgeInsets.all(padding),
            child: 
            GridView.count(
              // crossAxisCount: 3,
              //crossAxisCount: (isShortScreen ||  isLandscape) ? 4 : 3, // If the screen is short, we will show 4 buttons in a row, otherwise 3
              crossAxisCount: isLandscape ? 4 : 3,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling to fit the keypad in the available space
              shrinkWrap: true,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              children: 
              keys.map((key) { // keys is a list of strings representing keypad buttons
                // If the key is empty, we return an empty SizedBox to create a blank space
                
                if (key.isEmpty) {
                  return SizedBox(); // Nothing will be shown for empty key
                }
                
                bool isClear = key == "CLR"; // If key == "CLR" then isClear=True
                
                return ElevatedButton(
                  
                  onPressed: () {
                    if (isClear) { // if "CLR" button is pressed
                      // Call the onClear function to reset the amount and change map
                      onClear();
                    } 
                    
                    else {
                      onDigitPressed(key); // Call the onDigitPressed function with the pressed key
                      // This will append the digit to the amountStr and recalculate change
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
    return Container 
    (
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
    ),

      child: 
      Column( // "Taka" Label and er amount ekta column er moddhe rakhsi jate vertically aligned thake
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Text( // "Taka:" label
            "Taka:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),


          Text( // Takar Amount
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