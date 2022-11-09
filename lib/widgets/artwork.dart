import "package:flutter/material.dart";
import 'package:musicplayer/provider/song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Artwork extends StatelessWidget {
  const Artwork({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: QueryArtworkWidget(
        size: 250,
        id: context.watch<SongProvider>().id,
        type: ArtworkType.AUDIO,
        artworkFit: BoxFit.cover,
        artworkBorder: const BorderRadius.all(Radius.circular(200)),
        nullArtworkWidget: const Icon(
          Icons.music_note,
          size: 300,
        ),
      ),
    );
  }
}
