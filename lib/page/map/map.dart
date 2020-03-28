import 'package:app/app.dart';
import 'package:app/widget/og_social_buttons.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<OG> ogs;

  Future _loadData() async {
    ogs = await api.getOGs();
    setState(() {});
  }

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karte'),
      ),
      body: ogs == null
          ? LinearProgressIndicator()
          : FlutterMap(
              options: MapOptions(
                  center: LatLng(51.5167, 9.9167),
                  zoom: 5.7,
                  minZoom: 4,
                  maxZoom: 19),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://mapcache.fridaysforfuture.de/{z}/{x}/{y}.png',
                    tileProvider: CachedNetworkTileProvider()),
                MarkerLayerOptions(
                  markers:
                      ogs.map<Marker>((item) => _generateMarker(item)).toList(),
                ),
              ],
            ),
      /*   floatingActionButton: FloatingActionButton(onPressed: () {
        FirebaseMessaging().subscribeToTopic('topic');
      }), */
    );
  }

  Marker _generateMarker(OG og) {
    return Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(og.lat, og.lon),
        builder: (context) => new Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: Theme.of(context).primaryColor,
                iconSize: 45.0,
                onPressed: () {
                  showOGDetails(og);
                },
              ),
            ));
  }

  showOGDetails(OG og) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(og.name),
        content: OGSocialButtons(og, true),
        actions: <Widget>[
          FlatButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Abbrechen'),
          ),
          FlatButton(
            onPressed: () {
              // TODO Subscribe to ID and save
            },
            child: Text('Abonnieren'),
          ),
        ],
      ),
    );
  }
}
