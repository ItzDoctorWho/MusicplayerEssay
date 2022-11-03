import 'package:flutter/material.dart';
import 'package:musicplayer/pages/allsongs.dart';
import 'package:musicplayer/pages/favorites.dart';
import 'package:musicplayer/pages/playlists.dart';
import 'package:musicplayer/pages/search.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const AllSongs(),
    const Search(),
    const Favorites(),
    const Playlists(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: const Color(0xff185a9d),
          unselectedItemColor: Colors.black,
          selectedIconTheme: const IconThemeData(color: Color(0xff43cea2)),
          selectedItemColor: const Color.fromARGB(255, 14, 67, 50),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'All Songs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play),
              label: 'Playlists',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
