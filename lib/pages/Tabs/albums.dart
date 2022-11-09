import 'package:flutter/material.dart';
import 'package:musicplayer/pages/Tabs/albumsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({Key? key}) : super(key: key);

  Future<List<AlbumModel>> fetchAlbums() {
    var list = OnAudioQuery().queryAlbums();
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FutureBuilder(
            future: fetchAlbums(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].album),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      leading: QueryArtworkWidget(
                        id: snapshot.data![index].id,
                        type: ArtworkType.ALBUM,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 50,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumSongs(
                              title: snapshot.data[index].album,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
}
