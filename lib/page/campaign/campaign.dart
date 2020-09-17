import 'package:app/model/campaign.dart';
import 'package:app/model/campaign_page_data.dart';
import 'package:app/util/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quiver/iterables.dart';
import 'package:app/app.dart';

/*
The Campaign Page (Aktionen)
 */
class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  Iterable<List<Campaign>> campaignPairs;
  CampaignPageData data;
  var currentImage = 0;

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

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            enlargeCenterPage: true,
            onPageChanged: (index, _reason) {
              setState(() {
                currentImage = index;
              });
            },
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
        ),
        dotImageIndicator(),
      ],
    );
  }

  Widget dotImageIndicator() {
    final dotColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < data.banners.length; i++)
          Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    currentImage == i ? dotColor : dotColor.withOpacity(0.4)),
          ),
      ],
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
            ? LinearProgressIndicator()
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
