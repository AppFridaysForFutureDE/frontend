import 'package:app/model/feed_item.dart';
import 'package:app/model/home_page_data.dart';
import 'package:app/util/navigation.dart';
import 'package:app/widget/feed_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageData data;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    try {
      data = await api.getHomePageData();

      if (mounted) setState(() {});
    } catch (e) {
      print(e);

      if (mounted)
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
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
                    GestureDetector(
                      onTap: () {
                        NavUtil(context)
                            .openLink(data.banner.link, data.banner.inApp);
                      },
                      child: CachedNetworkImage(imageUrl: data.banner.imageUrl),
                    ),
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
                    for (final feedItem in data.feed)
                      HomeFeedItem(
                        feedItem,
                      ),
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
            dropCap: DropCap(
              width: 200,
              height: 38,
              child: RaisedButton(
                child: Text(item.cta),
                onPressed: () {
                  NavUtil(context).openLink(item.link, item.inApp);
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
