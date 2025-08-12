// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'base_client.dart'; // Make sure this path is correct
import 'entity_form.dart';
import 'edit_entity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'Map Markers from API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // KEY CHANGE 1: The Future is created once in initState and stored.
  late Future<String> _mapDataFuture;

  @override
  void initState() {
    debugPrint('🚀 MyHomePage.initState() - Starting initialization');
    super.initState();
    debugPrint('🌍 MyHomePage.initState() - Creating map data future');
    _mapDataFuture = BaseClient().get(''); // Call the API once
    debugPrint('✅ MyHomePage.initState() - Initialization completed');
  }

  void _showEnlargedImage(BuildContext context, String title, String imageUrl) {
    debugPrint('🖼️ MyHomePage._showEnlargedImage() - Showing enlarged image');
    debugPrint('📝 MyHomePage._showEnlargedImage() - Title: $title');
    debugPrint('🔗 MyHomePage._showEnlargedImage() - Image URL: $imageUrl');
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image: $error');
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    var imageBasePath = 'https://labs.anontech.info/cse489/t3/';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<String>(
        // Use the future from the state
        future: _mapDataFuture,
        builder: (context, snapshot) {
          debugPrint('📊 MyHomePage.build() - FutureBuilder state: ${snapshot.connectionState}');
          
          if (snapshot.connectionState != ConnectionState.done) {
            debugPrint('⏳ MyHomePage.build() - Still loading data...');
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('❌ MyHomePage.build() - Error in snapshot: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('❌ MyHomePage.build() - No data or empty data');
            debugPrint('📏 MyHomePage.build() - Data length: ${snapshot.data?.length ?? 0}');
            return const Center(child: Text('No data found'));
          }
          
          debugPrint('✅ MyHomePage.build() - Data received successfully');
          debugPrint('📏 MyHomePage.build() - Raw data length: ${snapshot.data!.length} characters');

          try {
            debugPrint('🔄 MyHomePage.build() - Decoding JSON data...');
            // Decode the JSON and expect a List
            final List<dynamic> entities = convert.jsonDecode(snapshot.data!);
            debugPrint('✅ MyHomePage.build() - JSON decoded successfully');
            debugPrint('📏 MyHomePage.build() - Found ${entities.length} entities');
            
            for (int i = 0; i < entities.length; i++) {
              debugPrint('📍 MyHomePage.build() - Entity $i: ${entities[i]}');
            }

            // KEY CHANGE 2: Create a list of Marker widgets from valid entities only.
            debugPrint('🗺 MyHomePage.build() - Creating markers from entities...');
            final List<Marker> markers = entities.where((entity) {
              // Filter out entities with invalid coordinates
              final latStr = entity['lat']?.toString() ?? '';
              final lonStr = entity['lon']?.toString() ?? '';
              final lat = double.tryParse(latStr);
              final lon = double.tryParse(lonStr);
              
              if (lat == null || lon == null || latStr.isEmpty || lonStr.isEmpty) {
                debugPrint('⚠️ MyHomePage.build() - Skipping entity ${entity['id']} from map due to invalid coordinates: lat="$latStr", lon="$lonStr"');
                return false;
              }
              return true;
            }).map((entity) {
            try {
              debugPrint('🔄 MyHomePage.build() - Processing entity: ${entity['id']}');
              
              // Parse coordinates (we know they're valid from the filter above)
              final lat = double.parse(entity['lat'].toString());
              final lon = double.parse(entity['lon'].toString());
              final title = entity['title'] as String;
              final imageUrl = "${imageBasePath}${entity['image']}";
              
              debugPrint('📍 MyHomePage.build() - Entity ${entity['id']}: lat=$lat, lon=$lon, title="$title"');
              debugPrint('🖼️ MyHomePage.build() - Entity ${entity['id']}: imageUrl="$imageUrl"');

              return Marker(
              point: LatLng(lat, lon),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  debugPrint('📍 MyHomePage.build() - Marker tapped for entity: ${entity['id']}');
                  debugPrint('📝 MyHomePage.build() - Showing bottom sheet for: $title');
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (sheetContext) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        maxChildSize: 0.9,
                        minChildSize: 0.3,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                              onTap: (){
                                debugPrint('🖼️ MyHomePage.build() - Image tapped in bottom sheet');
                                if(entity['image']==null) {
                                  debugPrint('❌ MyHomePage.build() - No image available for entity');
                                  return;
                                }
                                debugPrint('🔚 MyHomePage.build() - Closing bottom sheet and showing enlarged image');
                                Navigator.pop(sheetContext); // close sheet
                                Future.microtask(() => _showEnlargedImage(context, title, imageUrl));
                              },

                              child: Image.network(
                                imageUrl, // Replace with your image URL
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  if(entity['image']==null){
                                    return Text('Image Not Available On Remote Server');
                                  }
                                  else return Text('Error loading image: $error');
                                },
                                ),
                              ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.red,
                ),
              ),
            );
            } catch (e, stackTrace) {
              debugPrint('💥 MyHomePage.build() - Error processing entity ${entity['id']}: $e');
              debugPrint('📚 MyHomePage.build() - Stack trace: $stackTrace');
              // Return empty marker or handle error appropriately
              return Marker(
                point: LatLng(0, 0),
                width: 0,
                height: 0,
                child: Container(),
              );
            }
          }).toList();
          
          debugPrint('✅ MyHomePage.build() - Created ${markers.length} markers');

          debugPrint('🗺 MyHomePage.build() - Initializing FlutterMap...');
          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(23.777176, 90.399452), // Center on Dhaka
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app', // Use your app's identifier
              ),

              // KEY CHANGE 3: Use a single MarkerLayer for all markers.
              MarkerLayer(markers: markers),

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          );
          } catch (e, stackTrace) {
            debugPrint('💥 MyHomePage.build() - Exception in JSON parsing or UI building: $e');
            debugPrint('📚 MyHomePage.build() - Stack trace: $stackTrace');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error processing data: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('🔄 MyHomePage.build() - Retrying data fetch...');
                      setState(() {
                        _mapDataFuture = BaseClient().get('');
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Main Screen'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Entity Form'),
              onTap: () async {
                debugPrint('🗺 MyHomePage.drawer() - Entity Form menu item tapped');
                Navigator.pop(context);
                debugPrint('🚀 MyHomePage.drawer() - Navigating to EntityFormScreen');
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntityFormScreen(),
                  ),
                );
                debugPrint('🔙 MyHomePage.drawer() - Returned from EntityFormScreen with result: $result');
                // Refresh the map if an entity was created/updated
                if (result == true) {
                  debugPrint('🔄 MyHomePage.drawer() - Refreshing map data...');
                  setState(() {
                    _mapDataFuture = BaseClient().get('');
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Entity List'),
              onTap: () async {
                debugPrint('📋 MyHomePage.drawer() - Entity List menu item tapped');
                Navigator.pop(context);
                debugPrint('🚀 MyHomePage.drawer() - Navigating to EntityListScreen');
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntityListScreen(),
                  ),
                );
                debugPrint('🔙 MyHomePage.drawer() - Returned from EntityListScreen with result: $result');
                // Refresh the map if entities were modified
                if (result == true) {
                  debugPrint('🔄 MyHomePage.drawer() - Refreshing map data...');
                  setState(() {
                    _mapDataFuture = BaseClient().get('');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}