import 'package:app/model/feed_item.dart';
import 'package:app/model/home_page_data.dart';
import 'package:app/model/strike.dart';
import 'package:app/page/campaign/campaign.dart';
import 'package:app/util/navigation.dart';
import 'package:app/widget/feed_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

class HomePage extends StatefulWidget {
  final Function navigationRequest;

  HomePage(this.navigationRequest);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageData data;

  List<OG> subscribedOgs;

  @override
  void initState() {
    subscribedOgs = Hive.box('subscribed_ogs').values.toList().cast<OG>();
/*     if (subscribedOgs.isNotEmpty) {
      _currentOGId = subscribedOgs.first.ogId;
    } */
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    try {
      data = await api.getHomePageData();

      if (mounted) setState(() {});

      for (final og in subscribedOgs) {
        final strikes = await api.getStrikesByOG(og.ogId);
        Hive.box('strikes').put(og.ogId, strikes);
      }
      if (mounted) setState(() {});
    } catch (e) {
      print(e);

      if (mounted)
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  int _currentOG = 0;

  Widget _buildOGCard(OG og) {
    final strikes = (Hive.box('strikes').get(og.ogId) ?? []).cast<Strike>();

    Strike nextPlenum, nextStrike;

    List<Strike> plenumList = [];
    List<Strike> strikeList = [];
    for (Strike strike in strikes) {
      strike.name == 'Nächstes Plenum:'
          ? plenumList.insert(0, strike)
          : strikeList.insert(0, strike);
    }

    if (plenumList.length > 0)
      nextPlenum = plenumList.reduce(
          (curr, next) => curr.date.compareTo(next.date) > 0 ? curr : next);

    if (strikeList.length > 0)
      nextStrike = strikeList.reduce(
          (curr, next) => curr.date.compareTo(next.date) > 0 ? curr : next);

    return Container(
      child: InkWell(
        onTap: () {
          widget.navigationRequest(1);
        },
        child: Column(
          children: [
            Text(
              og.name,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (nextStrike == null && nextPlenum == null)
                  Text(
                    'Aktuell keine Events',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                if (nextStrike != null)
                  Text(
                    'Nächste Demo:\n${DateFormat('dd.MM.yyyy').format(nextStrike.dateTime)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                if (nextStrike != null && nextPlenum != null)
                  SizedBox(
                    width: 24,
                  ),
                if (nextPlenum != null)
                  Text(
                    'Nächstes Plenum:\n${DateFormat('dd.MM.yyyy').format(nextPlenum.dateTime)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: data == null
            ? LinearProgressIndicator()
            : Scrollbar(
                child: ListView(
                  children: <Widget>[
                    if ((data?.banner?.imageUrl ?? '') != '')
                      GestureDetector(
                        onTap: () {
                          NavUtil(context).openLink(
                              data.banner.link, data.banner.inApp, null);
                        },
                        child:
                            CachedNetworkImage(imageUrl: data.banner.imageUrl),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if (subscribedOgs.isNotEmpty) ...[
                      if (subscribedOgs.length == 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 86,
                            child: _buildOGCard(subscribedOgs.first),
                          ),
                        ),
                      if (subscribedOgs.length > 1)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 86.0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            enlargeCenterPage: true,
                            onPageChanged: (index, _reason) {
                              setState(() {
                                _currentOG = index;
                              });
                            },
                          ),
                          items: subscribedOgs.map((og) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: _buildOGCard(og),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      if (subscribedOgs.length > 1)
                        DotImageIndiciator(
                          length: subscribedOgs.length,
                          current: _currentOG,
                        ),
                      SizedBox(
                        height: 4,
                      ),
                    ],

                    /*   SizedBox(
                      height: 100,
                      child: CarouselSlider(
                        options: CarouselOptions(height: 400.0),
                        items: [
                          for (final OG og in Hive.box('subscribed_ogs')
                              .values
                              .toList()
                              .cast<OG>())
                            Text(og.name) // TODO After Merge
                        ], */

                    /*      [1, 2, 3, 4, 5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(color: Colors.amber),
                                  child: Text(
                                    'text $i',
                                    style: TextStyle(fontSize: 16.0),
                                  ));
                            },
                          );
                        }).toList(), */
                    /*     ),
                    ), */
                    for (final feedItem in data.feed)
                      HomeFeedItem(
                        feedItem,
                      ),
                    /*   for (final feedItem in data.feed)
                      HomeFeedItem(
                        feedItem,
                      ), */
                  ],
                ),
              ),
      ),
    );
  }
}

class HomeFeedItem extends StatelessWidget {
  final FeedItem item;

  HomeFeedItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (item.imageUrl?.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: DropCapText(
            item.text,
            style: Theme.of(context).textTheme.bodyText2,
            dropCapPosition: DropCapPosition.end,
            textAlign: TextAlign.start,
            dropCap: DropCap(
              width: 200,
              height: 38,
              child: RaisedButton(
                child: Text(item.cta),
                onPressed: () {
                  NavUtil(context).openLink(item.link, item.inApp, item.cta);
                },
              ),
            ),
          ),
        ),
        Divider(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
