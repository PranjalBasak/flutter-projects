import 'package:flutter/material.dart';
import 'dart:convert';
import 'base_client.dart';
import 'entity_form.dart';

class EntityListScreen extends StatefulWidget {
  const EntityListScreen({super.key});

  @override
  State<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
  late Future<List<Map<String, dynamic>>> _entitiesFuture;
  final String imageBasePath = 'https://labs.anontech.info/cse489/t3/';

  @override
  void initState() {
    debugPrint('🚀 EntityListScreen.initState() - Starting initialization');
    super.initState();
    _loadEntities();
    debugPrint('✅ EntityListScreen.initState() - Initialization completed');
  }

  void _loadEntities() {
    debugPrint('📊 EntityListScreen._loadEntities() - Loading entities from API');
    _entitiesFuture = _fetchEntities();
  }

  Future<List<Map<String, dynamic>>> _fetchEntities() async {
    debugPrint('🌐 EntityListScreen._fetchEntities() - Fetching entities from API');
    try {
      final response = await BaseClient().get('');
      debugPrint('✅ EntityListScreen._fetchEntities() - API response received');
      debugPrint('📏 EntityListScreen._fetchEntities() - Response length: ${response.length}');
      
      if (response == "No Data Found") {
        debugPrint('❌ EntityListScreen._fetchEntities() - No data found');
        return [];
      }
      
      final List<dynamic> jsonData = jsonDecode(response);
      debugPrint('✅ EntityListScreen._fetchEntities() - JSON decoded successfully');
      debugPrint('📏 EntityListScreen._fetchEntities() - Found ${jsonData.length} entities');
      
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      debugPrint('💥 EntityListScreen._fetchEntities() - Exception: $e');
      debugPrint('📚 EntityListScreen._fetchEntities() - Stack trace: $stackTrace');
      throw Exception('Failed to load entities: $e');
    }
  }

  Future<void> _editEntity(Map<String, dynamic> entity) async {
    debugPrint('✏️ EntityListScreen._editEntity() - Navigating to edit entity: ${entity['id']}');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityFormScreen(entity: entity),
      ),
    );
    
    debugPrint('🔙 EntityListScreen._editEntity() - Returned from edit with result: $result');
    if (result == true) {
      debugPrint('🔄 EntityListScreen._editEntity() - Refreshing entity list');
      setState(() {
        _loadEntities();
      });
      _showSnackBar('Entity updated successfully!');
    }
  }

  Future<void> _deleteEntity(Map<String, dynamic> entity) async {
    debugPrint('🗑️ EntityListScreen._deleteEntity() - Attempting to delete entity: ${entity['id']}');
    
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Entity'),
          content: Text('Are you sure you want to delete "${entity['title']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      debugPrint('✅ EntityListScreen._deleteEntity() - User confirmed deletion');
      try {
        debugPrint('🌐 EntityListScreen._deleteEntity() - Making DELETE API call');
        final response = await BaseClient().delete('?id=${entity['id']}');
        debugPrint('📝 EntityListScreen._deleteEntity() - API response: $response');
        
        if (response.startsWith('Error:')) {
          debugPrint('❌ EntityListScreen._deleteEntity() - API returned error: $response');
          _showSnackBar('Failed to delete entity: $response');
        } else {
          debugPrint('✅ EntityListScreen._deleteEntity() - Entity deleted successfully');
          _showSnackBar('Entity deleted successfully!');
          setState(() {
            _loadEntities();
          });
        }
      } catch (e, stackTrace) {
        debugPrint('💥 EntityListScreen._deleteEntity() - Exception: $e');
        debugPrint('📚 EntityListScreen._deleteEntity() - Stack trace: $stackTrace');
        _showSnackBar('Error deleting entity: $e');
      }
    } else {
      debugPrint('❌ EntityListScreen._deleteEntity() - User cancelled deletion');
    }
  }

  void _showSnackBar(String message) {
    debugPrint('📢 EntityListScreen._showSnackBar() - Message: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildEntityCard(Map<String, dynamic> entity) {
    final title = entity['title'] ?? 'No Title';
    final lat = entity['lat']?.toString() ?? 'N/A';
    final lon = entity['lon']?.toString() ?? 'N/A';
    final imageUrl = entity['image'] != null ? '$imageBasePath${entity['image']}' : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editEntity(entity);
                    } else if (value == 'delete') {
                      _deleteEntity(entity);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Location info
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Lat: $lat, Lon: $lon',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            // Image if available
            if (imageUrl != null) ...[
              const SizedBox(height: 12),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
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
                      return Container(
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Image not available', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _editEntity(entity),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _deleteEntity(entity),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('🔄 EntityListScreen.build() - Refresh button pressed');
              setState(() {
                _loadEntities();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _entitiesFuture,
        builder: (context, snapshot) {
          debugPrint('📊 EntityListScreen.build() - FutureBuilder state: ${snapshot.connectionState}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('⏳ EntityListScreen.build() - Loading entities...');
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            debugPrint('❌ EntityListScreen.build() - Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('🔄 EntityListScreen.build() - Retry button pressed');
                      setState(() {
                        _loadEntities();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          final entities = snapshot.data ?? [];
          debugPrint('✅ EntityListScreen.build() - Loaded ${entities.length} entities');
          
          if (entities.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No entities found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first entity using the form',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: entities.length,
            itemBuilder: (context, index) {
              return _buildEntityCard(entities[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('➕ EntityListScreen.build() - Add button pressed');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntityFormScreen(),
            ),
          );
          
          debugPrint('🔙 EntityListScreen.build() - Returned from create with result: $result');
          if (result == true) {
            debugPrint('🔄 EntityListScreen.build() - Refreshing entity list');
            setState(() {
              _loadEntities();
            });
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Entity',
      ),
    );
  }
}
