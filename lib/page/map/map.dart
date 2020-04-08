import 'package:app/app.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<OG> ogs;

  bool searchActive = false;
  String searchText = '';

  Future _loadData() async {
    ogs = await api.getOGs();
    if (mounted) setState(() {});
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
        title: searchActive
            ? TextField(
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onChanged: (s) {
                  setState(() {
                    searchText = s;
                  });
                },
              )
            : Text('Karte'),
        actions: <Widget>[
          if (ogs != null)
            IconButton(
              icon: Icon(searchActive ? Icons.close : MdiIcons.magnify),
              onPressed: () {
                setState(() {
                  if (searchActive) {
                    searchText = '';
                    searchActive = false;
                  } else {
                    searchActive = true;
                  }
                });
              },
            ),
        ],
      ),
      body: ogs == null
          ? LinearProgressIndicator()
          : (searchActive
              ? ListView(
                  children: <Widget>[
                    for (var og in ogs
                        .where((o) => o.name
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .take(21))
                      ListTile(
                        title: Text(og.name),
                        onTap: () {
                          showOGDetails(og);
                        },
                      )
                  ],
                )
              : FlutterMap(
                  options: MapOptions(
                    center: LatLng(51.3867, 9.9167),
                    zoom: 5.7,
                    minZoom: 4,
                    maxZoom: 19,
                    plugins: [
                      MarkerClusterPlugin(),
                    ],
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            'https://mapcache.fridaysforfuture.de/{z}/{x}/{y}.png',
                        tileProvider: CachedNetworkTileProvider()),
                    MarkerClusterLayerOptions(
                      maxClusterRadius: 120,
                      size: Size(40, 40),
                      fitBoundsOptions: FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                      ),
                      markers: ogs
                          .map<Marker>((item) => _generateMarker(item))
                          .toList(),
                      polygonOptions: PolygonOptions(
                          borderColor: Theme.of(context).primaryColor,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      builder: (context, markers) {
                        return FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            markers.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: null,
                        );
                      },
                    ),
                    /*    MarkerLayerOptions(
                    ), */
                  ],
                )),
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
                color: Hive.box('subscribed_ogs').containsKey(og.ogId)
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                iconSize: 45.0,
                onPressed: () {
                  showOGDetails(og);
                },
              ),
            ));
  }

  showOGDetails(OG og) {
    bool subscribed = Hive.box('subscribed_ogs').containsKey(og.ogId);
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
          subscribed
              ? FlatButton(
                  onPressed: () async {
                    Hive.box('subscribed_ogs').delete(og.ogId);
                    Navigator.of(context).pop();
                    await FirebaseMessaging()
                        .unsubscribeFromTopic('og_${og.ogId}');
                  },
                  child: Text('Deabonnieren'),
                )
              : FlatButton(
                  onPressed: () async {
                    Hive.box('subscribed_ogs').put(og.ogId, og);
                    Navigator.of(context).pop();
                    await FirebaseMessaging().subscribeToTopic('og_${og.ogId}');
                  },
                  child: Text('Abonnieren'),
                ),
        ],
      ),
    );
  }
}
