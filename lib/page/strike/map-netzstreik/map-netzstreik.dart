import 'package:app/page/strike/map-netzstreik/add-iframe-page.dart';
import 'package:app/page/strike/map-netzstreik/add-strike-page.dart';
import 'package:app/page/strike/map-netzstreik/filterNetzStrike.dart';
import 'package:app/page/strike/map-netzstreik/netzstreik-api.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app.dart';
import 'package:latlong/latlong.dart';

/**
 * A map that shows all Strike points for the global Climate strike on 04/24/2020
 */
class MapNetzstreik extends StatefulWidget {
  @override
  _MapNetzstreikState createState() => _MapNetzstreikState();
}

class _MapNetzstreikState extends State<MapNetzstreik> {
  NetzstreikApi netzstreikApi = NetzstreikApi();
  List<StrikePoint> strikePointL = List<StrikePoint>();
  bool onlyPicure = false;
  FilterStateNetz filterState = FilterStateNetz();

  var allFeaturedMarker = <Marker>[];
  var allNotFeaturedMarker = <Marker>[];

  var allImageMarkerFeatured = <Marker>[];
  var allImageMarkerNotFeatured = <Marker>[];
  
  var featuredMarkerShow = <Marker>[];
  var notFeaturedMarkerShow = <Marker>[];

  /**
   * The init Method Loads all strike Points.
   */
  @override
  void initState() {
    netzstreikApi.getAllStrikePoints().then((list) {
      if (mounted) {
        strikePointL = list;
        _generateAllMarker();
        setState(() {
          applayFilter();
          print("Neue daten sind");
        });
      }
    });

    super.initState();
  }

  /**
   * A Method that applays the Filter state to the List of the State.
   * it will NOT cause a Rebuild of the Screen
   */
  void applayFilter() {
    if (!filterState.filterActive) {
      featuredMarkerShow = allFeaturedMarker;
      notFeaturedMarkerShow = allNotFeaturedMarker;
    } else if (filterState.onlyShowImage) {
      featuredMarkerShow = this.allImageMarkerFeatured;
      notFeaturedMarkerShow = this.allImageMarkerNotFeatured;
    } else {
      print('Komishc');
    }
  }

  /**
   * Generates the Marker for one Strike Point
   */
  Marker _generateMarker(StrikePoint strikePoint) {
    if (!(strikePoint.imgStatus)) {
      if (strikePoint.isFeatured) {
        return Marker(
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
                ));
      } else {
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
    } else {
      return Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(strikePoint.lat, strikePoint.lon),
          builder: (context) => new Container(
                child: InkWell(
                  child: Image.network(
                    NetzstreikApi.strikeImageUrl + strikePoint.imgDir,
                  ),
                  onTap: () {
                    _showStrikePoint(strikePoint);
                  },
                ),
              ));
    }
  }

  /**
   * Genrates a list of Markes of not Features Strike Points and Puts them in the Lists
   */
  void _generateAllMarker() {
    for (StrikePoint strikePoint in strikePointL) {
      // After the and means filterState.onlyShowImage => strikepoint.imgStatus
      Marker marker = _generateMarker(strikePoint);

      if (strikePoint.isFeatured) {
        allFeaturedMarker.add(marker);
        if (strikePoint.imgStatus) {
          allImageMarkerFeatured.add(marker);
        }
      } else {
        allNotFeaturedMarker.add(marker);
        if (strikePoint.imgStatus) {
          allImageMarkerNotFeatured.add(marker);
        }
      }
    }
  }

  /**
   * Generates a list of Markers of all Features Strike Points
   * If Filters active it will only return the Filter matching Strike Points
   */
  /*
  List<StrikePoint> _getAllFeatured() {
    List<StrikePoint> resultL = [];
    for (StrikePoint strikePoint in strikePointL) {
      // After the and means filterState.onlyShowImage => strikepoint.imgStatus
      if (strikePoint.isFeatured &&
          (!filterState.onlyShowImage || strikePoint.imgStatus)) {
        Marker marker = (Marker(
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
        strikePoint.marker = marker;
        resultL.add(strikePoint);
      }
    }
    return resultL;
  }*/

  /**
   * Shows a Popup for a Strike point for example if a point is tapped
   */
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
              strikePoint.imgStatus
                  ? Image.network(
                      NetzstreikApi.strikeImageUrl + strikePoint.imgDir)
                  : Container(),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.filter),
            onPressed: () async {
              var newFilterState = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FilterNetzStrikePage(filterState),
                ),
              );

              if (newFilterState != null)
                setState(() {
                  filterState = newFilterState;
                  applayFilter();
                });
            },
          )
        ],
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
              // all Clusters (not featured marker)
              new MarkerLayerOptions(
                markers: this.featuredMarkerShow,
              ),
              if (!filterState.onlyShowFeatured)
                MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: Size(52, 52),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: this.notFeaturedMarkerShow,
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
              // all featured strike Points

              /*    MarkerLayerOptions(
                            ), */
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Color(0xaaffffff),
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '© OpenStreetMap-Mitwirkende',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          //The Expandable Info Text at the Top
          Column(mainAxisSize: MainAxisSize.min, children: [
            if (filterState.filterActive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.yellow,
                alignment: Alignment.center,
                child: Text(
                  'Es sind Filter aktiv',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              child: ExpandableNotifier(
                // <-- Provides ExpandableController to its children
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Expandable(
                    // <-- Driven by ExpandableController from ExpandableNotifier
                    collapsed: ExpandableButton(
                      // <-- Expands when tapped on the cover photo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Wir streiken weiter',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                              "Um die Ausbreitung des Coronavirus zu verlangsamen, Menschen zu schützen und unsere Gesundheitssysteme zu entlasten, müssen wir alle unser Handeln anpassen. Auch wir als Fridays for Future und wollen dem gerecht werden. Daher sagen wir alle Streiks in der echten Welt ab und verlagern unsere Proteste für eine bessere Klimapolitik ins Netz. Nach wie vor fordern wir, die Klimakrise nicht aus den Augen zu verlieren. Der Coronakrise muss ebenso wie der Klimakrise in aller Handlungsbereitschaft und mit dem notwendigen politischen Willen begegnet werden. Weiterhin bedroht die Klimakrise unsere Zukunft. Deswegen protestieren wir trotzdem lautstark weiter – ohne Menschenmassen; stattdessen digital und im Netz.",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          Center(
                            child: Text(
                              'weiterlesen',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .black //Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    expanded: ExpandableButton(
                      // <-- Collapses when tapped on
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wir streiken weiter',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                                "Um die Ausbreitung des Coronavirus zu verlangsamen, Menschen zu schützen und unsere Gesundheitssysteme zu entlasten, müssen wir alle unser Handeln anpassen. Auch wir als Fridays for Future und wollen dem gerecht werden. Daher sagen wir alle Streiks in der echten Welt ab und verlagern unsere Proteste für eine bessere Klimapolitik ins Netz. Nach wie vor fordern wir, die Klimakrise nicht aus den Augen zu verlieren. Der Coronakrise muss ebenso wie der Klimakrise in aller Handlungsbereitschaft und mit dem notwendigen politischen Willen begegnet werden. Weiterhin bedroht die Klimakrise unsere Zukunft. Deswegen protestieren wir trotzdem lautstark weiter – ohne Menschenmassen; stattdessen digital und im Netz.",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            Center(
                              child: Text("Einklappen",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                          ]),
                    ),
                  )
                ]),
              ),
            ),
            FlatButton(
              child: Text("Jetzt mitstreiken",
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white)),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                const url = 'https://actionmap.fridaysforfuture.de/iframe.html';

                launch(url);
                /*Navigator.push(
                  context,
                  //Pushes the Sub Page on the Stack
                  //MaterialPageRoute(builder: (context) => AddStrikePage(netzstreikApi)),
                   // MaterialPageRoute(builder: (context) => AddIFramePage())
                );*/
              },
            )
          ])
        ],
      ),
    );
  }
}
