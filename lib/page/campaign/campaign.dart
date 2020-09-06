import 'package:app/model/campaign.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:app/widget/title.dart';

/*
The Campaign Page
 */
class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Campaign> campaigns = [];

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
      campaigns = await api.getCampaigns();

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted)
        // TODO: Handle error "no Scaffold found" ? Maybe irrelevant - todo copied from slogans
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktionen'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: campaigns.isEmpty
            ? Center(
                child: Text('Keine Ergebnisse'),
              )
            : ListView(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: [1, 2, 3, 4, 5].map((i) {
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
                    }).toList(),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(campaigns.length, (index) {
                      Campaign campaign = campaigns[index];
                      return Center(
                        child: Padding(
                          // TODO: improve spacing
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                MdiIcons.fromString(campaign.icon),
                                color: Theme.of(context).accentColor,
                                size: 60,
                              ),
                              Text(
                                // TODO: fix overflow - make parent height flexible?
                                campaign.text,
                              ),
                              RaisedButton(
                                // TODO: Raised or Flat button?
                                // TODO: Make all buttons have the same size
                                color: Theme.of(context).primaryColor,
                                // TODO: really use round corners?
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                child: Text(
                                  campaign.cta,
                                  // TODO: fix to one line?
                                  // softWrap: false,
                                ),
                                onPressed: () {
                                  _launchURL(campaign.link);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
