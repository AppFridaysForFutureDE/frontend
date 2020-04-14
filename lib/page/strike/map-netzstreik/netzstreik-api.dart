import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:app/model/SocialLinkContainer.dart';
import 'package:app/service/cache.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class NetzstreikApi {

  static final apiUrl = 'https://actionmap.fridaysforfuture.de/?get_events';
  static final imageUrl = 'https://actionmap.fridaysforfuture.de/securimage/securimage_show.php';
  static final uploadUrl = 'https://actionmap.fridaysforfuture.de/index.php?upload';
  http.Client client = http.Client();
  Cookie cookie = null;
  Future<List<StrikePoint>> getAllStrikePoints() async{
    try {
      client = http.Client();
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
  Future<void> startUploadSession() async{
    var res = await client.get(apiUrl);
    var header = res.headers;
    var cookieRaw = header['set-cookie'];
    if(res.statusCode != HttpStatus.ok){
      throw Exception('Status Code: '+res.statusCode.toString());
    }
    if(cookieRaw != null){
      cookie = Cookie.fromSetCookieValue(cookieRaw);
      if(cookie != null){
        print(cookie.value);
        return ;
      }
    }
    throw new Exception( "Error start Upload Session");
  }
  Map<String, String> _getCookieHeader(){
    if(cookie == null){
      throw Exception('No Cookie set. Please first start upload Session');
    }
    Map<String, String> headers = {};
    headers['cookie'] = cookie.name +"="+cookie.value;
    return headers;
  }
  Future<Uint8List> getSecureImage() async{
    Map<String, String> headers = _getCookieHeader();
    var res = await client.get(imageUrl,headers:  headers);
    if(res.statusCode == HttpStatus.ok){
      print("ok");
      CacheService cache = CacheService(await getTemporaryDirectory());
      //cache.put('secureImage', res.body);
      return res.bodyBytes;
    }else{
      throw Exception('Not OK Status Code: '+res.statusCode.toString());
    }
  }
  Future<ResultUpload> finishUpload(String name, bool showName, String email, String plz, bool newsletter,String captcha) async{
    Map<String,dynamic> body = {};
    body['name'] = name;
    body['show_name'] = showName? 'true' : 'false';
    body['email'] = email;
    print(email);
    body['laender'] = plz;
    body['newsletter'] = newsletter ? 'true' : 'false';
    body['accept_eula'] = 'true';
    body['captcha_code'] = captcha;

    Map<String, String> headers = _getCookieHeader();
    var res = await client.post(uploadUrl,headers:headers,body: body);
    if(res.statusCode == HttpStatus.ok){
      print("Workes!! HEader");
      print(res.headers.toString());
      print("Body");
      print(res.body);
      return ResultUpload.Ok;
    }else{
      print("Fail ");
      return ResultUpload.Fail;
    }
  }

}
enum ResultUpload{
  Ok,Captcha,Fail
}
class StrikePoint implements SocialLinkContainer{
  String name = "";
  String place = "";
  String city = "";
  double lat = 0.0;
  double lon = 0.0;
  String text;
  bool imgStatus;
  String imgDir;
  bool isFeatured = false;
  String facebook = "";
  String website = "";
  String twitter = "";
  String instagram = "";
  @override
  String email;

  @override
  String other;

  @override
  String telegram;

  @override
  String whatsapp;

  @override
  String youtube;

  //StrikePoint(this.name, this.place, this.text, this.imgStatus, this.imgDir,
  //    );

  StrikePoint.fromJSON(dynamic json){
    name = json['name'] ?? "";
    place = json['place'] ?? "";
    imgDir = json['img_dir'] ?? "";
    imgStatus = json['img_status'] == 'confirmed';
    imgDir = json['img_dir'] ?? "";
    text = json['text'] ?? "";
    isFeatured = json['featured'] ?? false;
    if(json['links'] != null){
      var links  = json['links'];

      facebook = links['facebook'] ?? "";
      instagram = links['instagram'] ?? "";
      twitter = links['twitter'] ?? "";
      website = links['website'] ?? "";
      whatsapp = links['whatsapp'] as String ?? "";
      email = links['email'] as String ?? "";
      telegram = links['telegram'] as String ?? "";
      youtube = links['youtube'] as String ?? "";
      other = links['other'] as String ?? "";

    }

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
    return "Strike Point: Name $name, Place: $place, twitter $twitter, lon $lon | lat $lat";
  }


}