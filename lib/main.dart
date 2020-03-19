import 'package:app/page/about/about.dart';
import 'package:app/page/feed/feed.dart';
import 'package:app/page/info/info.dart';
import 'package:app/page/map/map.dart';
import 'package:app/service/api.dart';

import 'package:app/app.dart';

void main() {
  api = ApiService();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFF App DE',
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xff1DA64A),
        accentColor: Color(0xff1B7340),
        textTheme: TextTheme(body1: TextStyle(color: Colors.black)),
      ),
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
}
