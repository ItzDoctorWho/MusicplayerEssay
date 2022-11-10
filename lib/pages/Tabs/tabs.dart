import 'package:flutter/material.dart';
import 'package:musicplayer/pages/Tabs/albums.dart';
import 'package:musicplayer/pages/Navigation/allsongs.dart';
import 'package:musicplayer/pages/Tabs/artists.dart';

class TabNav extends StatefulWidget {
  const TabNav({Key? key}) : super(key: key);

  @override
  State<TabNav> createState() => _TabNavState();
}

class _TabNavState extends State<TabNav> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Music Player'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.music_note),
                  text: 'All Songs',
                ),
                Tab(
                  icon: Icon(Icons.album),
                  text: 'Albums',
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Artists',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AllSongs(),
              AlbumsList(),
              Artists(),
            ],
          ),
        ),
      );
}
