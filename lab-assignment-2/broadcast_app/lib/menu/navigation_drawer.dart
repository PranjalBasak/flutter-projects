import 'package:flutter/material.dart';
import 'package:broadcast_app/pages/home_page.dart';
import 'package:broadcast_app/pages/image_scale_page.dart';
import 'package:broadcast_app/pages/video_player_page.dart';
import 'package:broadcast_app/pages/audio_player_page.dart';

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
            builder: (context) => const HomePage(),
            ));
        },
      ),
      ListTile(
        leading: const Icon(Icons.image),
        title: const Text('Image Scale'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ImageScalePage(),
            ));
        }
      ),
      ListTile(
        leading: const Icon(Icons.movie),
        title: const Text('Video'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const VideoPlayerPage(),
            ));
        },
      ),
      ListTile(
        leading: const Icon(Icons.audio_file),
        title: const Text('Audio'),
        onTap: ()  {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AudioPlayerPage(),
            ));
        },
      ),
      ]),
  );
}