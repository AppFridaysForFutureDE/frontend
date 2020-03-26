import 'dart:convert';

import 'package:app/app.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List _strikeList = List();

  Future<List> eventData() async {
    const String url =
        'https://www.fridaysforfuture.org/events/map'; // removing `?d=All` from url since this amount of data kills any mobile CPU :wow:
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var regex = new RegExp(r"eventmap_data \= (.*);");
      String line = regex.firstMatch(response.body).group(1);
      List eventData = json.decode(line);
      if (mounted)
        setState(() {
          _strikeList = eventData;
        });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    eventData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _strikeList.isEmpty
        ? LinearProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Karte'),
            ),
            body: FlutterMap(
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
                  markers: _strikeList
                      .map<Marker>((item) => _generateMarker(item))
                      .toList(),
                ),
              ],
            ),
          );
  }

  Marker _generateMarker(var item) {
    return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(
            item['lat'] is String ? double.parse(item['lat']) : item['lat'],
            item['lon'] is String ? double.parse(item['lon']) : item['lon']),
        builder: (ctx) => GestureDetector(
              onTap: () {
                /*            showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          constraints: BoxConstraints(maxWidth: 768),
                          child: StrikeDetail(
                            strikeData: item,
                            hideHeader: false,
                          ),
                        ))); */
              },
              child: Column(
                children: <Widget>[
                  SpeechBubble(
                    nipLocation: NipLocation.BOTTOM,
                    color: Theme.of(context).primaryColor,
                    borderRadius: 16,
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    height: 32,
                    width: 32,
                    padding: const EdgeInsets.all(2),
                  ),
                  // undoing required offset by the SpeechBubble
                  SizedBox(
                    height: 28,
                  )
                ],
              ),
            ));
  }
}
