import 'package:app/page/about/about.dart';
import 'package:app/page/feed/feed.dart';
import 'package:app/page/info/info.dart';
import 'package:app/page/map/map.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFF App DE',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(_currentIndex),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.newspaper),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Karte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('Infos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountGroup),
            title: Text('Über uns'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return FeedPage();
      case 1:
        return MapPage();
      case 2:
        return InfoPage();
      case 3:
        return AboutPage();
      default:
        return Container();
    }
  }

  Widget _buildAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text('Newsfeed'),
        );
      case 1:
        return AppBar(
          title: Text('Karte'),
        );
      case 2:
        return AppBar(
          title: Text('Aktuelle Infos'),
        );
      case 3:
        return AppBar(
          title: Text('Über uns'),
        );
      default:
        return AppBar();
    }
  }
}
