import 'package:flutter/material.dart';
import 'package:broadcast_app/menu/navigation_drawer.dart' as custom_nav;
import 'package:photo_view/photo_view.dart';


class ImageScalePage extends StatelessWidget {
  const ImageScalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: custom_nav.NavigationDrawer(), 
      appBar: AppBar(
        title: const Text('Image Scale Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: AssetImage('assets/images/owl.jpg'),
          minScale: PhotoViewComputedScale.contained * 1.0,
          maxScale: PhotoViewComputedScale.covered * 5.0,
          initialScale: PhotoViewComputedScale.contained * 1.0,
          backgroundDecoration: BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}