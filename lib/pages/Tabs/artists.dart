import 'package:flutter/material.dart';
import 'package:musicplayer/pages/Tabs/artistsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Artists extends StatelessWidget {
  const Artists({Key? key}) : super(key: key);

  Future<List<Object>> _fetchArtists() {
    var artistsList = OnAudioQuery().queryArtists();
    return artistsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _fetchArtists(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data[index].artist),
                trailing: const Icon(Icons.arrow_forward_rounded),
                leading: const Icon(Icons.star_border_purple500),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtistsSongs(
                        title: snapshot.data[index].artist,
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
    ));
  }
}
