import 'package:flutter/material.dart';

import '../../../model/songs/rich_song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.richSong,
    required this.isPlaying,
    required this.onTap,
  });

  final RichSong richSong;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,

          leading: CircleAvatar(
            backgroundImage: NetworkImage(richSong.song.imageUrl.toString()),
          ),
          
          title: Text(richSong.song.title),
          subtitle: Text("${richSong.song.duration.inMinutes} mins    ${richSong.artist.name} - ${richSong.artist.genre}"),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
