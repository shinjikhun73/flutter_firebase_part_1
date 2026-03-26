import '../../model/artists/artist.dart';
import 'song.dart';

class RichSong {
  final Song song;
  final Artist artist;

  RichSong({
    required this.song,
    required this.artist,
  });

  @override
  String toString() {
    return 'RichSong(song: ${song.title}, artist: ${artist.name})';
  }
}
