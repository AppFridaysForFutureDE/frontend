import 'package:app/model/strike.dart';

import 'package:app/page/about/about.dart';
import 'package:app/page/about/about_subpage/privacy.dart';
import 'package:app/page/feed/feed.dart';
import 'package:app/page/info/info.dart';
import 'package:app/page/map/map.dart';
import 'package:app/service/api.dart';

import 'package:app/app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(OGAdapter());
  Hive.registerAdapter(StrikeAdapter());

  await Hive.openBox('data');

  await Hive.openBox('post_read');
  await Hive.openBox('post_mark');

  await Hive.openBox('subscribed_ogs');

  await Hive.openBox('strikes');

  await Hive.openBox('acceptet');

  await initializeDateFormatting('de_DE', null);

  api = ApiService();

  await api.loadConfig();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primaryColor: Color(0xff1DA64A),
        accentColor: Color(0xfff5333f),
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'FFF App DE',
          home: Home(),
          theme: theme,
        );
      },
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // Test if the Privacy agreement is already acceptet
    if(Hive.box('acceptet').get('isAcceptet') == null || !Hive.box('acceptet').get('isAcceptet')){
      return PrivacyPage.onStart(setState);
    }else {
      return Scaffold(
        body: _buildPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (mounted)
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
