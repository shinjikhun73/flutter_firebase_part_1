import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../data/repositories/artists/artist_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../../model/artists/artist.dart';
import '../../../../model/songs/rich_song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<RichSong>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository, 
    required this.artistRepository, 
    required this.playerState
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Song> songs = await songRepository.fetchSongs();
      List<Artist> artists = await artistRepository.fetchArtists();

      Map<String, Artist> artistMap = {for (var a in artists) a.id: a};

      List<RichSong> richSongs = songs.map((song) {
        Artist? artist = artistMap[song.artistId];
        // Provide a fallback if artist is not found, or use a default
        artist ??= Artist(id: song.artistId, name: 'Unknown', genre: 'Unknown', imageUrl: Uri.parse(''));
        return RichSong(song: song, artist: artist);
      }).toList();

      songsValue = AsyncValue.success(richSongs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
     notifyListeners();

  }

  bool isSongPlaying(RichSong richSong) => playerState.currentSong == richSong.song;

  void start(RichSong richSong) => playerState.start(richSong.song);
  void stop(RichSong richSong) => playerState.stop();
}
