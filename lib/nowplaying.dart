import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/provider/song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key, required this.song, required this.audioPlayer})
      : super(key: key);
  final SongModel song;
  final AudioPlayer audioPlayer;
  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    playsong();
  }

  playsong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.song.uri!),
        ),
      );
      widget.audioPlayer.play();
      isPlaying = true;
    } catch (e) {
      log("error parsing uri");
    }
    widget.audioPlayer.durationStream.listen(
      (event) {
        setState(() {
          duration = event!;
        });
      },
    );
    widget.audioPlayer.positionStream.listen(
      (event) {
        setState(() {
          position = event;
        });
      },
    );
  }

  void siderchange(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Artwork(),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.song.artist.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                        ),
                        iconSize: 40,
                        onPressed: null,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle,
                        ),
                        iconSize: 60,
                        onPressed: () {
                          setState(() {
                            isPlaying = !isPlaying;
                            isPlaying == true
                                ? widget.audioPlayer.play()
                                : widget.audioPlayer.pause();
                          });
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const IconButton(
                        icon: Icon(
                          Icons.skip_next,
                        ),
                        iconSize: 40,
                        onPressed: null,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position.toString().split(".")[0]),
                      Text(duration.toString().split(".")[0]),
                    ],
                  ),
                  Slider(
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) {
                      siderchange(value.toInt());
                    },
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.shuffle,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.repeat,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.more_horiz,
                        size: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Artwork extends StatelessWidget {
  const Artwork({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: QueryArtworkWidget(
        size: 500,
        id: context.watch<SongProvider>().id,
        type: ArtworkType.AUDIO,
        artworkFit: BoxFit.cover,
        artworkBorder: const BorderRadius.all(Radius.circular(20)),
        nullArtworkWidget: const Icon(
          Icons.music_note,
          size: 300,
        ),
      ),
    );
  }
}
