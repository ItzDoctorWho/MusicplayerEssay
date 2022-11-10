import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/provider/song_provider.dart';
import 'package:musicplayer/widgets/artwork.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying(
      {Key? key, required this.songList, required this.audioPlayer})
      : super(key: key);
  final List<SongModel> songList;
  final AudioPlayer audioPlayer;
  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  List<AudioSource> songs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    playsong();
  }

  playsong() {
    try {
      for (var element in widget.songList) {
        songs.add(AudioSource.uri(
          Uri.parse(element.uri!),
          tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.title,
              artist: element.artist ?? "No Artist",
              artUri: Uri.parse(element.id.toString())),
        ));
      }

      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songs,
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
    listenToSongIndex();
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongProvider>()
                .setId(widget.songList[currentIndex].id);
          },
        );
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
      backgroundColor: Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(213, 0, 0, 0),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              )),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Stack(
              children: [
                Center(
                  child: SleekCircularSlider(
                    initialValue: position.inSeconds.toDouble(),
                    onChange: (value) {
                      siderchange(value.toInt());
                    },
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    innerWidget: (percentage) {
                      return const Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Artwork(),
                      );
                    },
                    appearance: CircularSliderAppearance(
                        counterClockwise: false,
                        size: 330,
                        customColors: CustomSliderColors(
                            progressBarColor:
                                const Color.fromARGB(255, 106, 106, 106),
                            dotColor: Colors.black,
                            trackColor: Colors.grey.withOpacity(.4)),
                        customWidths: CustomSliderWidths(
                            trackWidth: 6,
                            handlerSize: 10,
                            progressBarWidth: 6)),
                  ),
                ),
                Positioned(
                  left: 40,
                  top: 270,
                  child: GestureDetector(
                    child: Text(
                      position.toString().split(".")[0].split(":")[0] == "0"
                          ? "${position.toString().split(".")[0].split(":")[1]}:${position.toString().split(".")[0].split(":")[2]}"
                          : position.toString().split(".")[0],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 270,
                  child: Text(
                    duration.toString().split(".")[0].split(":")[0] == "0"
                        ? "${duration.toString().split(".")[0].split(":")[1]}:${duration.toString().split(".")[0].split(":")[2]}"
                        : duration.toString().split(".")[0],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.songList[currentIndex].title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.songList[currentIndex].artist.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (widget.audioPlayer.hasPrevious) {
                            widget.audioPlayer.seekToPrevious();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                        ),
                        iconSize: 40,
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
                      IconButton(
                        onPressed: () {
                          if (widget.audioPlayer.hasNext) {
                            widget.audioPlayer.seekToNext();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next,
                        ),
                        iconSize: 40,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
