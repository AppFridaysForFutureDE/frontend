import 'package:app/model/campaign.dart';
import 'package:app/model/campaign_page_data.dart';
import 'package:app/util/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quiver/iterables.dart';
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
  CampaignPageData data;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    try {
      data = await api.getCampaignPageData();
      campaignPairs = partition(data.campaigns, 2);

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted)
        // TODO: Handle error "no Scaffold found": Add scaffold key and use it here
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  Widget _bannerImage(banner) {
    return GestureDetector(
      onTap: () {
        NavUtil(context).openLink(banner.link, banner.inApp);
      },
      child: CachedNetworkImage(imageUrl: banner.imageUrl),
    );
  }

  Widget bannerCarousel() {
    if (data.banners.length == 1) return _bannerImage(data.banners.first);

    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
      ),
      items: data.banners.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: _bannerImage(i));
          },
        );
      }).toList(),
    );
  }

  Widget campaignColumn(Campaign campaign) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                NavUtil(context).openLink(campaign.link, campaign.inApp);
              },
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
        title: Text('Aktionen'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: campaignPairs == null
            ? Center(
                child: Text('Keine Ergebnisse'),
              )
            : ListView(
                children: <Widget>[
                  bannerCarousel(),
                  for (var pair in campaignPairs)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        campaignColumn(pair[0]),
                        pair.length > 1
                            ? campaignColumn(pair[1])
                            : Expanded(child: Text('')),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
