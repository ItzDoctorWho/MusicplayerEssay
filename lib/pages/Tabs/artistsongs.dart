import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/pages/player/nowplaying.dart';
import 'package:musicplayer/provider/song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ArtistsSongs extends StatelessWidget {
  ArtistsSongs({Key? key, required this.title}) : super(key: key);
  final String title;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];

  Future<List<SongModel>> _fetchArtistsSongs() async {
    List<dynamic> artistsSongs = await _audioQuery.queryWithFilters(
      title,
      WithFiltersType.AUDIOS,
      args: AudiosArgs.ARTIST,
    );
    List<SongModel> convertedSongs = artistsSongs.toSongModel();
    return convertedSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Songs'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<SongModel>>(
          future: _fetchArtistsSongs(),
          builder: (context, item) {
            allSongs.addAll(item.data!);
            if (item.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (item.data!.isEmpty) return const Text("Nothing found!");
            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 50,
                    ),
                  ),
                  onTap: () {
                    context.read<SongProvider>().setId(item.data![index].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                          songList: allSongs.sublist(index),
                          audioPlayer: _audioPlayer,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
