import 'dart:io'; // used for Plattform identification

import 'package:app/model/strike.dart';

import 'package:app/page/about/about.dart';
import 'package:app/page/feed/feed.dart';
import 'package:app/page/info/info.dart';
import 'package:app/page/map/map.dart';
import 'package:app/page/strike/strike.dart';
import 'package:app/service/api.dart';

import 'package:app/app.dart';
import 'package:app/service/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  await initializeDateFormatting('de_DE', null);

  api = ApiService();

  await api.loadConfig();

  api.updateOGs();

  runApp(App());
}

class App extends StatelessWidget {
  ThemeData _buildThemeData(String theme) {
    var _accentColor = Color(0xff70c2eb);

    var brightness =
        ['light', 'sepia'].contains(theme) ? Brightness.light : Brightness.dark;

    var themeData = ThemeData(
      brightness: brightness,
      accentColor: _accentColor,
      primaryColor: Color(0xff1da64a),
      toggleableActiveColor: _accentColor,
      highlightColor: _accentColor,
      buttonColor: _accentColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _accentColor,
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: _accentColor,
      ),
      textTheme: TextTheme(
        button: TextStyle(color: _accentColor),
      ),
      fontFamily: 'LibreFranklin',
    );

    if (theme == 'sepia') {
      Color backgroundColor = Color(0xffF7ECD5);
      themeData = themeData.copyWith(
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        canvasColor: backgroundColor,
      );
    } else if (theme == 'black') {
      Color backgroundColor = Colors.black;
      themeData = themeData.copyWith(
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        canvasColor: backgroundColor,
      );
    }

    //sets the Background for the IOs Subtitles depending on the theme Brightness
    if (Platform.isIOS) {
      if (brightness == Brightness.dark) {
        themeData = themeData.copyWith(
            textTheme: themeData.textTheme.copyWith(
                subtitle: themeData.textTheme.subtitle
                    .copyWith(backgroundColor: Colors.grey[800])));
      } else {
        themeData = themeData.copyWith(
            textTheme: themeData.textTheme.copyWith(
                subtitle: themeData.textTheme.subtitle
                    .copyWith(backgroundColor: Colors.grey[100])));
      }
    }
    return themeData;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AppTheme(
      data: (theme) => _buildThemeData(theme),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'App For Future',
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

  void subToAll() async {
    Box box = Hive.box('data');
    for (String cat in feedCategories) {
      await FirebaseMessaging().subscribeToTopic('feed_$cat');
      box.put('feed_$cat', true);
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    if (Hive.box('data').get('firstStart') ?? true) {
      if (Platform.isIOS) {
        _firebaseMessaging.requestNotificationPermissions();
        _firebaseMessaging.configure();
      }
      subToAll();
      Hive.box('data').put('firstStart', false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Column(children: <Widget>[
            Expanded(child: child),
            if (!connected)
              Container(
                color: Theme.of(context).accentColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Die App ist aktuell offline",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
          ]);
        },
        child: _buildPage(_currentIndex),
      ),
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
            icon: Icon(Icons.flag),
            title: Text('Netzstreik'),
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
        return StrikePage();
      case 3:
        return InfoPage();
      case 4:
        return AboutPage();
      default:
        return Container();
    }
  }
}
