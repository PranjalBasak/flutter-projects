import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:broadcast_app/menu/navigation_drawer.dart' as custom_nav;
import 'dart:async';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isCompleted = false;
  late final StreamSubscription<PlayerState> _playerStateSub;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
    _playerStateSub = _audioPlayer.playerStateStream.listen((state) { // store subscription
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isCompleted = state.processingState == ProcessingState.completed;
        });
      }
    });
  }

  Future<void> _init() async {
    await _audioPlayer.setAsset('assets/audio/test.mp3');
  }

  @override
  void dispose() {
    _playerStateSub.cancel(); // cancelled subscription
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _restart() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: custom_nav.NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Audio Player Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.audiotrack, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text('Sample Audio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            if (_isCompleted)
              ElevatedButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: const Text('Restart'),
                onPressed: _restart,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                    iconSize: 56,
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.restart_alt),
                    iconSize: 40,
                    onPressed: _restart,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}