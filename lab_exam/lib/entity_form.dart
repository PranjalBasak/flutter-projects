import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'base_client.dart';

class EntityFormScreen extends StatefulWidget {
  final Map<String, dynamic>? entity; // For editing existing entity
  
  const EntityFormScreen({super.key, this.entity});

  @override
  State<EntityFormScreen> createState() => _EntityFormScreenState();
}

class _EntityFormScreenState extends State<EntityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  
  File? _selectedImage;
  bool _isLoading = false;
  bool _isGettingLocation = false;
  
  @override
  void initState() {
    debugPrint('🚀 EntityFormScreen.initState() - Starting initialization');
    super.initState();
    if (widget.entity != null) {
      debugPrint('✏️ EntityFormScreen.initState() - Editing mode detected');
      debugPrint('📄 EntityFormScreen.initState() - Entity data: ${widget.entity}');
      // Pre-fill form for editing
      _titleController.text = widget.entity!['title'] ?? '';
      _latController.text = widget.entity!['lat']?.toString() ?? '';
      _lonController.text = widget.entity!['lon']?.toString() ?? '';
      debugPrint('📝 EntityFormScreen.initState() - Form pre-filled with existing data');
    } else {
      debugPrint('➕ EntityFormScreen.initState() - Create mode detected');
    }
    debugPrint('✅ EntityFormScreen.initState() - Initialization completed');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    debugPrint('📍 EntityFormScreen._getCurrentLocation() - Starting location fetch');
    setState(() {
      _isGettingLocation = true;
    });

    try {
      debugPrint('🔐 EntityFormScreen._getCurrentLocation() - Checking location permissions...');
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('🔐 EntityFormScreen._getCurrentLocation() - Current permission: $permission');
      
      if (permission == LocationPermission.denied) {
        debugPrint('🔐 EntityFormScreen._getCurrentLocation() - Requesting location permission...');
        permission = await Geolocator.requestPermission();
        debugPrint('🔐 EntityFormScreen._getCurrentLocation() - Permission after request: $permission');
        if (permission == LocationPermission.denied) {
          debugPrint('❌ EntityFormScreen._getCurrentLocation() - Location permissions denied');
          _showSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ EntityFormScreen._getCurrentLocation() - Location permissions permanently denied');
        _showSnackBar('Location permissions are permanently denied');
        return;
      }

      debugPrint('📡 EntityFormScreen._getCurrentLocation() - Getting current position...');
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      debugPrint('📍 EntityFormScreen._getCurrentLocation() - Position received: lat=${position.latitude}, lon=${position.longitude}');
      debugPrint('📍 EntityFormScreen._getCurrentLocation() - Accuracy: ${position.accuracy}m');

      setState(() {
        _latController.text = position.latitude.toString();
        _lonController.text = position.longitude.toString();
      });
      
      debugPrint('✅ EntityFormScreen._getCurrentLocation() - Location updated successfully');
      _showSnackBar('Location updated successfully');
    } catch (e, stackTrace) {
      debugPrint('💥 EntityFormScreen._getCurrentLocation() - Exception: $e');
      debugPrint('📚 EntityFormScreen._getCurrentLocation() - Stack trace: $stackTrace');
      _showSnackBar('Error getting location: $e');
    } finally {
      debugPrint('🔚 EntityFormScreen._getCurrentLocation() - Finalizing location fetch');
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<void> _pickImage() async {
    debugPrint('🖼️ EntityFormScreen._pickImage() - Starting image picker from gallery');
    try {
      final ImagePicker picker = ImagePicker();
      debugPrint('📱 EntityFormScreen._pickImage() - Opening image picker...');
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('✅ EntityFormScreen._pickImage() - Image selected: ${image.path}');
        debugPrint('📏 EntityFormScreen._pickImage() - Image size: ${await image.length()} bytes');
        
        File imageFile = File(image.path);
        
        debugPrint('🔄 EntityFormScreen._pickImage() - Starting image resize...');
        // Resize image to 800x600
        File resizedImage = await _resizeImage(imageFile);
        
        setState(() {
          _selectedImage = resizedImage;
        });
        
        debugPrint('✅ EntityFormScreen._pickImage() - Image processing completed');
        _showSnackBar('Image selected and resized to 800x600');
      } else {
        debugPrint('❌ EntityFormScreen._pickImage() - No image selected');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 EntityFormScreen._pickImage() - Exception: $e');
      debugPrint('📚 EntityFormScreen._pickImage() - Stack trace: $stackTrace');
      _showSnackBar('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    debugPrint('📷 EntityFormScreen._takePhoto() - Starting camera');
    try {
      final ImagePicker picker = ImagePicker();
      debugPrint('📱 EntityFormScreen._takePhoto() - Opening camera...');
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('✅ EntityFormScreen._takePhoto() - Photo taken: ${image.path}');
        debugPrint('📏 EntityFormScreen._takePhoto() - Photo size: ${await image.length()} bytes');
        
        File imageFile = File(image.path);
        
        debugPrint('🔄 EntityFormScreen._takePhoto() - Starting image resize...');
        // Resize image to 800x600
        File resizedImage = await _resizeImage(imageFile);
        
        setState(() {
          _selectedImage = resizedImage;
        });
        
        debugPrint('✅ EntityFormScreen._takePhoto() - Photo processing completed');
        _showSnackBar('Photo taken and resized to 800x600');
      } else {
        debugPrint('❌ EntityFormScreen._takePhoto() - No photo taken');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 EntityFormScreen._takePhoto() - Exception: $e');
      debugPrint('📚 EntityFormScreen._takePhoto() - Stack trace: $stackTrace');
      _showSnackBar('Error taking photo: $e');
    }
  }

  Future<File> _resizeImage(File imageFile) async {
    debugPrint('🔄 EntityFormScreen._resizeImage() - Starting image resize');
    debugPrint('📁 EntityFormScreen._resizeImage() - Original file: ${imageFile.path}');
    
    try {
      // Read image
      debugPrint('📚 EntityFormScreen._resizeImage() - Reading image bytes...');
      Uint8List imageBytes = await imageFile.readAsBytes();
      debugPrint('📏 EntityFormScreen._resizeImage() - Original image size: ${imageBytes.length} bytes');
      
      debugPrint('🔍 EntityFormScreen._resizeImage() - Decoding image...');
      img.Image? originalImage = img.decodeImage(imageBytes);
      
      if (originalImage == null) {
        debugPrint('❌ EntityFormScreen._resizeImage() - Could not decode image');
        throw Exception('Could not decode image');
      }
      
      debugPrint('📊 EntityFormScreen._resizeImage() - Original dimensions: ${originalImage.width}x${originalImage.height}');

      // Resize to 800x600
      debugPrint('🔄 EntityFormScreen._resizeImage() - Resizing to 800x600...');
      img.Image resizedImage = img.copyResize(
        originalImage,
        width: 800,
        height: 600,
        interpolation: img.Interpolation.linear,
      );
      
      debugPrint('✅ EntityFormScreen._resizeImage() - Resize completed: ${resizedImage.width}x${resizedImage.height}');

      // Encode as JPEG
      debugPrint('💾 EntityFormScreen._resizeImage() - Encoding as JPEG...');
      Uint8List resizedBytes = img.encodeJpg(resizedImage, quality: 85);
      debugPrint('📏 EntityFormScreen._resizeImage() - Encoded size: ${resizedBytes.length} bytes');

      // Save to temporary file
      String tempPath = imageFile.path.replaceAll('.jpg', '_resized.jpg')
          .replaceAll('.png', '_resized.jpg')
          .replaceAll('.jpeg', '_resized.jpg');
      
      debugPrint('📁 EntityFormScreen._resizeImage() - Saving to: $tempPath');
      File resizedFile = File(tempPath);
      await resizedFile.writeAsBytes(resizedBytes);
      
      debugPrint('✅ EntityFormScreen._resizeImage() - Image resize completed successfully');
      return resizedFile;
    } catch (e, stackTrace) {
      debugPrint('💥 EntityFormScreen._resizeImage() - Exception: $e');
      debugPrint('📚 EntityFormScreen._resizeImage() - Stack trace: $stackTrace');
      rethrow;
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    debugPrint('🚀 EntityFormScreen._submitForm() - Starting form submission');
    
    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ EntityFormScreen._submitForm() - Form validation failed');
      return;
    }
    
    debugPrint('✅ EntityFormScreen._submitForm() - Form validation passed');

    setState(() {
      _isLoading = true;
    });
    
    debugPrint('📝 EntityFormScreen._submitForm() - Preparing entity data...');

    try {
      // Prepare data
      Map<String, dynamic> entityData = {
        'title': _titleController.text.trim(),
        'lat': double.parse(_latController.text),
        'lon': double.parse(_lonController.text),
      };
      
      debugPrint('📊 EntityFormScreen._submitForm() - Basic data: $entityData');

      // Don't add image to entityData - it will be handled separately as a file
      if (_selectedImage != null) {
        debugPrint('🖼️ EntityFormScreen._submitForm() - Image will be uploaded as multipart file');
        debugPrint('📁 EntityFormScreen._submitForm() - Image file: ${_selectedImage!.path}');
      } else {
        debugPrint('🚫 EntityFormScreen._submitForm() - No image selected');
      }

      String result;
      if (widget.entity != null) {
        debugPrint('✏️ EntityFormScreen._submitForm() - Update mode - adding entity ID');
        entityData['id'] = widget.entity!['id'];
        debugPrint('🆔 EntityFormScreen._submitForm() - Entity ID: ${widget.entity!['id']}');
        debugPrint('🔄 EntityFormScreen._submitForm() - Making PUT request...');
        result = await BaseClient().put('', entityData, imageFile: _selectedImage);
      } else {
        debugPrint('➕ EntityFormScreen._submitForm() - Create mode');
        debugPrint('🔄 EntityFormScreen._submitForm() - Making POST request...');
        result = await BaseClient().post('', entityData, imageFile: _selectedImage);
      }
      
      debugPrint('💬 EntityFormScreen._submitForm() - API response: $result');

      if (result.startsWith('Error:')) {
        debugPrint('❌ EntityFormScreen._submitForm() - API returned error: $result');
        _showSnackBar(result);
      } else {
        debugPrint('✅ EntityFormScreen._submitForm() - Success!');
        _showSnackBar(widget.entity != null 
            ? 'Entity updated successfully!' 
            : 'Entity created successfully!');
        debugPrint('🔙 EntityFormScreen._submitForm() - Navigating back with success result');
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e, stackTrace) {
      debugPrint('💥 EntityFormScreen._submitForm() - Exception: $e');
      debugPrint('📚 EntityFormScreen._submitForm() - Stack trace: $stackTrace');
      _showSnackBar('Error: $e');
    } finally {
      debugPrint('🔚 EntityFormScreen._submitForm() - Finalizing submission');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    debugPrint('📢 EntityFormScreen._showSnackBar() - Message: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entity != null ? 'Edit Entity' : 'Create Entity'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Location Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Latitude Field
                      TextFormField(
                        controller: _latController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter latitude';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          double lat = double.parse(value);
                          if (lat < -90 || lat > 90) {
                            return 'Latitude must be between -90 and 90';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Longitude Field
                      TextFormField(
                        controller: _lonController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter longitude';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          double lon = double.parse(value);
                          if (lon < -180 || lon > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Get Current Location Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isGettingLocation ? null : _getCurrentLocation,
                          icon: _isGettingLocation 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location),
                          label: Text(_isGettingLocation 
                              ? 'Getting Location...' 
                              : 'Use Current Location'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Image Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image (Optional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      if (_selectedImage != null) ...[
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Image will be resized to 800x600 pixels',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.image),
                              label: Text(_selectedImage != null 
                                  ? 'Change Image' 
                                  : 'Select Image'),
                            ),
                          ),
                          if (_selectedImage != null) ...[
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Remove'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Processing...'),
                          ],
                        )
                      : Text(
                          widget.entity != null ? 'Update Entity' : 'Create Entity',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
