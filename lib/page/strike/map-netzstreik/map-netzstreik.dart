import 'package:app/page/strike/map-netzstreik/netzstreik-api.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import '../../../app.dart';
import 'package:latlong/latlong.dart';

class MapNetzstreik extends StatefulWidget {
  @override
  _MapNetzstreikState createState() => _MapNetzstreikState();
}

class _MapNetzstreikState extends State<MapNetzstreik> {
  NetzstreikApi netzstreikApi = NetzstreikApi();
  List<StrikePoint> strikePointL = List<StrikePoint>();
  @override
  void initState() {
    netzstreikApi.getAllStrikePoints().then((list) {
      if (mounted) {
        setState(() {
          strikePointL = list;
        });
      }
    });

    super.initState();
  }

  Marker _generateMarker(StrikePoint strikePoint) {
    return Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(strikePoint.lat, strikePoint.lon),
        builder: (context) => new Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: strikePoint.isFeatured
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                iconSize: 45.0,
                onPressed: () {
                  _showStrikePoint(strikePoint);
                },
              ),
            ));
  }

  List<Marker> _getAllNotFeatured() {
    List<Marker> resultL = [];
    for (StrikePoint strikePoint in strikePointL) {
      if (!strikePoint.isFeatured) {
        resultL.add(_generateMarker(strikePoint));
      }
    }
    return resultL;
  }

  List<Marker> _getAllFeatured() {
    List<Marker> resultL = [];
    for (StrikePoint strikePoint in strikePointL) {
      if (strikePoint.isFeatured) {
        resultL.add(Marker(
            width: 45.0,
            height: 45.0,
            point: LatLng(strikePoint.lat, strikePoint.lon),
            builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Theme.of(context).accentColor,
                    iconSize: 45.0,
                    onPressed: () {
                      _showStrikePoint(strikePoint);
                    },
                  ),
                )));
      }
    }
    return resultL;
  }

  void _showStrikePoint(StrikePoint strikePoint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            (strikePoint.name == "") ? "Ein Aktivisti*" : strikePoint.name),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text((strikePoint.text == "") ? " " : strikePoint.text),
              SocialButtons(strikePoint, true).build(context),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Streik Karte"),
      ),
      body: Stack(
        children: [
          FlutterMap(
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
                markers: _getAllNotFeatured(),
                polygonOptions: PolygonOptions(
                    borderColor: Theme.of(context).primaryColor,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                builder: (context, markers) {
                  return FloatingActionButton(
                    heroTag: markers
                        .map<String>((marker) {
                          return marker.point.latitude.toString() +
                              marker.point.longitude.toString();
                        })
                        .toList()
                        .toString(),
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
              new MarkerLayerOptions(
                markers: _getAllFeatured(),
              ),

              /*    MarkerLayerOptions(
                            ), */
            ],
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              child: ExpandableNotifier(
                // <-- Provides ExpandableController to its children
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Wir streiken weiter',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.white),
                    ),
                    Expandable(
                      // <-- Driven by ExpandableController from ExpandableNotifier
                      collapsed: ExpandableButton(
                        // <-- Expands when tapped on the cover photo
                        child: RichText(
                          text: TextSpan(
                            text: 'Wir streiken weiter Lorem ipsum dolor sit amet, consete ... ',
                            //style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: '       weiterlesen', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                              )
                              ),
                            ],
                          ),
                        ),
                      ),
                      expanded: Column(children: [
                        Text(
                            "Wir streiken weiter Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        ExpandableButton(
                          // <-- Collapses when tapped on
                          child: Text("Einklappen",
                          style:TextStyle(
                            color: Theme.of(context).accentColor
                          )),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              child: Text(
                  "Jetzt mitstreiken",
                  style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ])
        ],
      ),
    );
  }
}