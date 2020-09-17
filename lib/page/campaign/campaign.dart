import 'package:app/model/campaign.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quiver/iterables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';

/*
The Campaign Page
 */
class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  Iterable<List<Campaign>> campaignPairs;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _loadData() async {
    try {
      var campaigns = await api.getCampaigns();
      campaignPairs = partition(campaigns, 2);

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted)
        // TODO: Handle error "no Scaffold found": Add scaffold key and use it here
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  Widget campaignColumn(Campaign campaign) {
    return Expanded(
      child: Column(
        // TODO align icons at top
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            MdiIcons.fromString(campaign.icon),
            color: Theme.of(context).accentColor,
            size: 60,
          ),
          Text(
            campaign.text,
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              campaign.cta,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              _launchURL(campaign.link);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktionen'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: campaignPairs == null
            ? Center(
                child: Text('Keine Ergebnisse'),
              )
            : Scrollbar(
                child: ListView(
                  children: <Widget>[
                    Image.network(
                        'https://fridaysforfuture.de/wp-content/uploads/2020/08/cropped-header.jpg'),
                    // TODO: Load banners from api and fix layout
                    // CarouselSlider(
                    //   options: CarouselOptions(height: 400.0),
                    //   items: [1, 2, 3, 4, 5].map((i) {
                    //     return Builder(
                    //       builder: (BuildContext context) {
                    //         return Container(
                    //             width: MediaQuery.of(context).size.width,
                    //             margin: EdgeInsets.symmetric(horizontal: 5.0),
                    //             decoration: BoxDecoration(color: Colors.amber),
                    //             child: Text(
                    //               'text $i',
                    //               style: TextStyle(fontSize: 16.0),
                    //             ));
                    //       },
                    //     );
                    //   }).toList(),
                    // ),
                    for (var pair in campaignPairs)
                      Row(
                        children: [
                          campaignColumn(pair[0]),
                          pair.length > 1 ? campaignColumn(pair[1]) : Text(''),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
