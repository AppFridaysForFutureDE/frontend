import 'dart:io';
import 'dart:convert';
import 'package:app/service/cache.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class NetzstreikApi {

  static final apiUrl = 'https://actionmap.fridaysforfuture.de/?get_events';
  Future<List<StrikePoint>> getAllStrikePoints() async{
    try {
      http.Client client = http.Client();
      var res = await client.get(apiUrl);
      if(res.statusCode == HttpStatus.ok){
        CacheService cache = CacheService(await getTemporaryDirectory());
        cache.put('netzstreikMap.json', res.body);
        var data = json.decode(res.body);
        List<StrikePoint>  resultL = data['entries'].map<StrikePoint>((m) => StrikePoint.fromJSON(m)).toList();
        for(StrikePoint point in resultL){
          var place = data['places'][point.place];
          if(place != null){
            point.city = place['city'];
            point.lon = double.tryParse(place['lon']) ?? 0.0 ;
            point.lat = double.tryParse(place['lat']) ?? 0.0 ;

          }
        }
        return resultL;
      }else{
        throw Exception("Not a valid respond from Server: " + res.statusCode.toString());
      }
    }
    catch(e){
      throw Exception('Error Loading entrys Strike Map\n '+e.toString() + '\n Error fertig');
    }
  }
}
class StrikePoint{
  String name = "";
  String place = "";
  String city = "";
  double lat = 0.0;
  double lon = 0.0;
  String text;
  bool imgStatus;
  String imgDir;
  Map<String,String> linkMap;

  StrikePoint(this.name, this.place, this.text, this.imgStatus, this.imgDir,
      this.linkMap);

  StrikePoint.fromJSON(dynamic json){
    name = json['name'] ?? "";
    place = json['place'] ?? "";
    imgDir = json['img_dir'] ?? "";
    imgStatus = json['img_status'] == 'confirmed';
    imgDir = json['img_dir'] ?? "";
    linkMap = _getLinkMap(json['links']) ?? "";
    text = json['text'] ?? "";

  }
  Map<String,String> _getLinkMap(dynamic jsonMap) {
    Map<String,String> resultM = Map<String,String>();
    if(jsonMap == null){
      return resultM;
    }
    for(String key in jsonMap.keys){
      resultM[key] = jsonMap[key];
    }

    return resultM;

  }
  @override
  String toString() {
    return "Strike Point: Name $name, Place: $place, Links Map: $linkMap, lon $lon | lat $lat";
  }
}