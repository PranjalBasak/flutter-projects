import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:broadcast_app/menu/navigation_drawer.dart' as custom_nav;

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoController =
        VideoPlayerController.asset('assets/videos/worlds_smallest_cat.mp4')
          ..initialize().then((_) {
            if (!mounted) return; 
            _chewieController = ChewieController(
              videoPlayerController: _videoController,
              autoPlay: false,
              looping: false,
              allowPlaybackSpeedChanging: true,
              showControls: true,
            );
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: custom_nav.NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Video Player Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Center(
        child: _chewieController != null &&
                _videoController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.pause(); 
    _chewieController?.dispose();
    _videoController.dispose();
    
    super.dispose();
  }
}

