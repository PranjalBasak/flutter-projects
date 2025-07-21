import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:pinch_zoom/pinch_zoom.dart';
// import 'package:fluttertoast_example/toast_context.dart';
// import 'package:fluttertoast_example/toast_no_context.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/material.dart';
//import 'package:flutter_broadcasts/flutter_broadcasts.dart';

/// Flutter code sample for [Scaffold].

void main() => runApp(const SimpleBroadcastApp());

class SimpleBroadcastApp extends StatelessWidget {
  const SimpleBroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BroadcastReceiverPage());
  }
}

class BroadcastReceiverPage extends StatefulWidget {
  const BroadcastReceiverPage({super.key});

  @override
  State<BroadcastReceiverPage> createState() => _BroadcastReceiverPageState();
}

class _BroadcastReceiverPageState extends State<BroadcastReceiverPage> {
  // int _count = 0;
  String selectedBroadcastType = 'Custom broadcast receiver';

  final List<String> broadcastTypes = [
    'Custom broadcast receiver',
    'System battery notification receiver'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Receiver'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
        ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text("Select a broadcast type",
              style: TextStyle(
                fontSize: 24, // Set your desired font size here
              ),
              ),
            ),

            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedBroadcastType,
              items: broadcastTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBroadcastType = newValue;
                  });
                }
              },

              
            ),

            const SizedBox(height: 100),
            ElevatedButton(
                onPressed: () {
                  if (selectedBroadcastType == 'Custom broadcast receiver') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          CustomBroadcastInputPage(),
                      ),
                    );
                  } else if (selectedBroadcastType ==
                      'System battery notification receiver') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SystemBatteryInfoPage(),
                      ),
                    );
                  }
                },
                child: const Text('Next'),
              ),
            

          ],
        ),
      ),
      drawer: NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          buildMenuItems(context),
        ]
      )
    )
  );



  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
        leading: const Icon(Icons.broadcast_on_home),
        title: const Text('Broadcast Receiver'),
        onTap: ()  {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BroadcastReceiverPage(),
            ));
        },
      ),
      ListTile(
        leading: const Icon(Icons.image),
        title: const Text('Image Scale'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ImageScalePage(),
            ));
        }
      ),
      ListTile(
        leading: const Icon(Icons.movie),
        title: const Text('Video'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const VideoPlayerPage(),
            ));
        },
      ),
      ListTile(
        leading: const Icon(Icons.audio_file),
        title: const Text('Audio'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AudioPlayerPage(),
            ));
        },
      ),
      ]),
  );
}











class CustomBroadcastInputPage extends StatefulWidget {
  const CustomBroadcastInputPage({super.key});
  @override
  CustomBroadcastInputPageState createState() => CustomBroadcastInputPageState();
}


class CustomBroadcastInputPageState extends State<CustomBroadcastInputPage> {
  final TextEditingController _textController = TextEditingController();
  final String broadcastName = "de.kevlatus.broadcast";

  final BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );

  @override
  void initState() {
    super.initState();
    try {
      receiver.start();
      // Listen to broadcast messages and show toast
      receiver.messages.listen((message) {
        print('Received broadcast: $message');
        _showToast(message);
      });
    } catch (e, stack) {
      print('Broadcast receiver start failed: $e');
      print(stack);
    }
  }

  @override
  void dispose() {
    receiver.stop();
    _textController.dispose();
    super.dispose();
  }

  void _showToast(dynamic message) {
    String toastMessage = '';
    
    if (message is BroadcastMessage) {
      // Extract data from BroadcastMessage
      //toastMessage = 'Broadcast: ${message.name}\nData: ${message.data}';
      toastMessage = '${message.data?["user_text"]}';
    } else {
      // Handle other message types
      toastMessage = 'Received: $message';
    }

    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    //drawer: NavigationDrawer(),
    appBar: AppBar(
      title: const Text('Custom Broadcast Receiver'),
      backgroundColor: const Color.fromARGB(255, 57, 126, 216),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a text to broadcast',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String userText = _textController.text.trim();
              sendBroadcast(
                BroadcastMessage(
                  name: "de.kevlatus.flutter_broadcasts_example.demo_action",
                  data: {
                    "user_text": userText.isNotEmpty ? userText : "default"
                  },
                  
                )
              );
              _textController.clear();
            },
            child: const Text('Send Broadcast'),
          ),
        ],
      ),
    ),
  );
}




class SystemBatteryInfoPage extends StatefulWidget {
  const SystemBatteryInfoPage({super.key});

  @override
  State<SystemBatteryInfoPage> createState() => _SystemBatteryInfoPageState();
}

class _SystemBatteryInfoPageState extends State<SystemBatteryInfoPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    // Poll battery level every 5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = level;
      });
    } catch (e) {
      // In case of an error, show -1
      setState(() {
        _batteryLevel = -1;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Battery Info Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Center(
        child: Text(
          _batteryLevel >= 0
              ? 'Battery Level: $_batteryLevel%'
              : 'Error retrieving battery level',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



/* Masked Out Audio Player Page*/
class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late final AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;
  bool _isPlaying = false;
  bool _isSeeking = false;
  bool _isCompleted = false;
  bool _isMuted = false;
  double _lastVolume = 1.0;

  final List<double> _speedOptions = [0.5, 1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await _audioPlayer.setAsset('assets/audio/test.mp3');
    _duration = _audioPlayer.duration ?? Duration.zero;
    setState(() {});
    _audioPlayer.positionStream.listen((pos) {
      if (!_isSeeking) {
        setState(() {
          _position = pos;
        });
      }
    });
    _audioPlayer.durationStream.listen((dur) {
      setState(() {
        _duration = dur ?? Duration.zero;
      });
    });
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        _isCompleted = state.processingState == ProcessingState.completed;
      });
    });
    _audioPlayer.volumeStream.listen((vol) {
      setState(() {
        _volume = vol;
        _isMuted = _volume == 0.0;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '${d.inHours > 0 ? '${twoDigits(d.inHours)}:' : ''}$minutes:$seconds';
  }

  void _seekTo(Duration position) async {
    setState(() => _isSeeking = true);
    await _audioPlayer.seek(position);
    setState(() => _isSeeking = false);
  }

  void _skipForward() {
    final newPos = _position + const Duration(seconds: 10);
    _seekTo(newPos < _duration ? newPos : _duration);
  }

  void _skipBackward() {
    final newPos = _position - const Duration(seconds: 10);
    _seekTo(newPos > Duration.zero ? newPos : Duration.zero);
  }

  void _setPlaybackSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
    setState(() => _playbackSpeed = speed);
  }

  void _setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
    setState(() => _volume = volume);
  }

  void _toggleMute() async {
    if (_isMuted) {
      // Unmute: restore last nonzero volume or default to 1.0
      double restoreVolume = _lastVolume > 0 ? _lastVolume : 1.0;
      await _audioPlayer.setVolume(restoreVolume);
      setState(() {
        _isMuted = false;
        _volume = restoreVolume;
      });
    } else {
      // Mute: save current volume
      _lastVolume = _volume > 0 ? _volume : (_lastVolume > 0 ? _lastVolume : 1.0);
      await _audioPlayer.setVolume(0.0);
      setState(() {
        _isMuted = true;
        _volume = 0.0;
      });
    }
  }

  void _restart() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Audio Player Page'),
        backgroundColor: const Color.fromARGB(255, 57, 126, 216),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text('Sample Audio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // Seekbar
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              initialData: _position,
              builder: (context, snapshot) {
                final pos = snapshot.data ?? Duration.zero;
                return Row(
                  children: [
                    Text(_formatDuration(pos)),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: _duration.inMilliseconds.toDouble(),
                        value: pos.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                        onChanged: (value) {
                          // Only update UI onChangeEnd for smoothness
                        },
                        onChangeEnd: (value) {
                          _seekTo(Duration(milliseconds: value.round()));
                        },
                      ),
                    ),
                    Text(_formatDuration(_duration)),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // Controls
            if (_isCompleted)
              ElevatedButton.icon(
                icon: Icon(Icons.restart_alt),
                label: Text('Restart'),
                onPressed: _restart,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    iconSize: 36,
                    onPressed: _skipBackward,
                  ),
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
                  IconButton(
                    icon: Icon(Icons.forward_10),
                    iconSize: 36,
                    onPressed: _skipForward,
                  ),
                ],
              ),
            const SizedBox(height: 24),
            // Playback speed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed:'),
                const SizedBox(width: 8),
                DropdownButton<double>(
                  value: _playbackSpeed,
                  items: _speedOptions
                      .map((speed) => DropdownMenuItem(
                            value: speed,
                            child: Text('${speed}x'),
                          ))
                      .toList(),
                  onChanged: (speed) {
                    if (speed != null) _setPlaybackSpeed(speed);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Volume
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _toggleMute,
                  child: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 1,
                    value: _volume,
                    onChanged: (value) {
                      _setVolume(value);
                      if (value == 0.0) {
                        setState(() => _isMuted = true);
                      } else {
                        setState(() => _isMuted = false);
                        _lastVolume = value;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}













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
      drawer: NavigationDrawer(),
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
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}






class ImageScalePage extends StatelessWidget {
  const ImageScalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(), // Replace with your NavigationDrawer
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









