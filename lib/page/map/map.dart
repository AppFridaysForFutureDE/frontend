import 'package:app/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  final List<OG> ogs;

  MapPage(this.ogs);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karte'),
      ),
      body: widget.ogs == null
          ? LinearProgressIndicator()
          : Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Semantics(
                  hidden: true,
                  enabled: false,
                  child: FlutterMap(
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
                        // TODO tileProvider: CachedNetworkTileProvider(),
                      ),
                      MarkerClusterLayerOptions(
                        maxClusterRadius: 120,
                        size: Size(40, 40),
                        fitBoundsOptions: FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: widget.ogs
                            .map<Marker>((item) => _generateMarker(item))
                            .toList(),
                        polygonOptions: PolygonOptions(
                            borderColor: Theme.of(context).primaryColor,
                            color: Colors.black12,
                            borderStrokeWidth: 3),
                        builder: (context, markers) {
                          return FloatingActionButton(
                            heroTag: null,
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
                    ],
                  ),
                ),
                Semantics(
                  hidden: true,
                  child: Container(
                    color: Color(0xaaffffff),
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '© OpenStreetMap-Mitwirkende',
                      style: TextStyle(fontSize: 11, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
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
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  width: 5,
                  color: Theme.of(context).accentColor,
                  // style: BorderStyle.solid
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      og.name,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 32,
                          ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text('Abbrechen'),
                        ),
                        subscribed
                            ? FlatButton(
                                onPressed: () async {
                                  Hive.box('subscribed_ogs').delete(og.ogId);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                  await FirebaseMessaging.instance
                                      .unsubscribeFromTopic('og_${og.ogId}');
                                },
                                child: Text('Deabonnieren'),
                              )
                            : FlatButton(
                                onPressed: () async {
                                  Hive.box('subscribed_ogs').put(og.ogId, og);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                  await FirebaseMessaging.instance
                                      .subscribeToTopic('og_${og.ogId}');
                                },
                                child: Text('Abonnieren'),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
