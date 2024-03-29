import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:app/model/SocialLinkContainer.dart';
import 'package:app/service/cache.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class NetzstreikApi {
  static final apiUrl = 'https://actionmap.fridaysforfuture.de/get_events';
  static final imageUrl =
      'https://actionmap.fridaysforfuture.de/securimage/securimage_show.php';
  static final uploadUrl =
      'https://actionmap.fridaysforfuture.de/index.php?upload';

  static final strikeImageUrl = 'https://actionmap.fridaysforfuture.de/';
  Uint8List secureImageDebug;
  http.Client client = http.Client();
  Cookie cookie;

  Future<void> makeCache() async {
    //Whait all in all 5 seconds
    await Future.delayed(Duration(seconds: 1));
    CacheService cache = CacheService(await getTemporaryDirectory());
    if (cache.exists('netzstreikMap.json')) {
      var body = cache.get('netzstreikMap.json');
      if (body != null) {
        return;
      }
    }
    if ((Hive.box('data').get('firstStart') ?? true)) {
      await Future.delayed(Duration(seconds: 4));

      try {
        client = http.Client();
        var res = await client.get(Uri.parse(apiUrl));
        if (res.statusCode == HttpStatus.ok) {
          cache.put('netzstreikMap.json', res.body);
          print('New Strike Data put in Cache');
          return;
        } else {
          throw Exception(
              "Not a valid respond from Server: " + res.statusCode.toString());
        }
      } catch (e) {
        throw Exception('Error Loading entrys Strike Map\n ' +
            e.toString() +
            '\n Error fertig');
      }
    }
  }

  Future<List<StrikePoint>> getAllStrikePointsOld() async {
    CacheService cache = CacheService(await getTemporaryDirectory());
    try {
      var body = cache.get('netzstreikMap.json');
      if (body == null) {
        return <StrikePoint>[];
      }
      var data = json.decode(body);
      List<StrikePoint> resultL = data['entries']
          .map<StrikePoint>((m) => StrikePoint.fromJSON(m))
          .toList();
      for (StrikePoint point in resultL) {
        var place = data['places'][point.place];
        if (place != null) {
          point.city = place['city'];
          point.lon = double.tryParse(place['lon']) ?? 0.0;
          point.lat = double.tryParse(place['lat']) ?? 0.0;
        }
      }
      return resultL;
    } catch (e) {
      print("Now Cache loaded jet");
      return <StrikePoint>[];
    }

    //if (cache.exists('netzstreikMap.json')) {

    //}
    /*
    else{
      print("No cache Bei strike points old");
      return  List<StrikePoint>();
    }
*/
  }

  Future<List<StrikePoint>> getAllStrikePoints() async {
    try {
      client = http.Client();
      var res = await client.get(Uri.parse(apiUrl));
      if (res.statusCode == HttpStatus.ok) {
        CacheService cache = CacheService(await getTemporaryDirectory());

        cache.put('netzstreikMap.json', res.body);

        var data = json.decode(res.body);
        List<StrikePoint> resultL = data['entries']
            .map<StrikePoint>((m) => StrikePoint.fromJSON(m))
            .toList();
        for (StrikePoint point in resultL) {
          var place = data['places'][point.place];
          if (place != null) {
            point.city = place['city'];
            point.lon = double.tryParse(place['lon']) ?? 0.0;
            point.lat = double.tryParse(place['lat']) ?? 0.0;
          }
        }

        return resultL;
      } else {
        throw Exception(
            "Not a valid respond from Server: " + res.statusCode.toString());
      }
    } catch (e) {
      throw Exception('Error Loading entrys Strike Map\n ' +
          e.toString() +
          '\n Error fertig');
    }
  }

  Future<void> startUploadSession() async {
    var res = await client.get(Uri.parse(apiUrl));
    var header = res.headers;
    var cookieRaw = header['set-cookie'];
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Status Code: ' + res.statusCode.toString());
    }
    if (cookieRaw != null) {
      cookie = Cookie.fromSetCookieValue(cookieRaw);
      if (cookie != null) {
        print(cookie.value);
        return;
      }
    }
    throw new Exception("Error start Upload Session");
  }

  Map<String, String> _getCookieHeader() {
    if (cookie == null) {
      throw Exception('No Cookie set. Please first start upload Session');
    }
    Map<String, String> headers = {};
    headers['cookie'] = cookie.name + "=" + cookie.value;
    return headers;
  }

  Future<Uint8List> getSecureImage() async {
    Map<String, String> headers = _getCookieHeader();
    var res = await client.get(Uri.parse(imageUrl), headers: headers);
    if (res.statusCode == HttpStatus.ok) {
      print("ok");
      // CacheService cache = CacheService(await getTemporaryDirectory());
      //cache.put('secureImage', res.body);
      secureImageDebug = res.bodyBytes;
      return res.bodyBytes;
    } else {
      throw Exception('Not OK Status Code: ' + res.statusCode.toString());
    }
  }

  Future<ResultUpload> finishUpload(String name, bool showName, String email,
      String plz, bool newsletter, String captcha) async {
    //-----
    /*
    Map<String,dynamic> body = {};

    body['name'] = name;
    body['show_name'] = showName? 'on' : 'off';
    body['email'] = email;
    print(email);
    body['laender'] = plz;
    //body['newsletter'] = newsletter ? 'on' : 'off';
    body['captcha_code'] = captcha;
    body['accept_eula'] = 'on';
    body['image'] = "''";
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
    */
    //----------

    /*
    var request = new http.MultipartRequest("POST", Uri.dataFromString(uploadUrl));
    request.fields['name'] = name;
    request.fields['show_name'] = showName? 'on' : 'off';
    request.fields['email'] = email;
    request.fields['laender'] = plz;
    request.fields['captcha_code'] = captcha;
    request.fields['accept_eula'] = 'on';
    request.fields['image'] = '';

     */

    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      'name': name,
      'show_name': showName ? 'on' : 'off',
      'email': email,
      'laender': plz,
      'captcha_code': captcha,
      'accept_eula': 'on',
      'image': MultipartFile.fromBytes(secureImageDebug)
      //"image":  /await MultipartFile.fromFile("assets/icon/icon.png",filename: "icon.png")
    });

    Response response = await dio.post(uploadUrl,
        data: formData,
        options: Options(
          headers: _getCookieHeader(),
        ));
    //var res  = await request.s;
    if (response.statusCode == HttpStatus.ok) {
      print("Workes!! HEader");
      print(response.headers.toString());
      print("Body");
      print(response.data);
      return ResultUpload.Ok;
    } else {
      print("Fail ");
      return ResultUpload.Fail;
    }

    //MediaType type = http.MediaType();
    //http.MultipartFile.fromPath('image', filePath)

    //var res = await request.send();
  }
}

enum ResultUpload { Ok, Captcha, Fail }

class StrikePoint implements SocialLinkContainer {
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

  StrikePoint.fromJSON(dynamic json) {
    name = json['name'] ?? "";
    place = json['place'] ?? "";
    imgDir = json['img_dir'] ?? "";
    imgStatus = json['img_status'] == 'confirmed';
    imgDir = json['img_dir'] ?? "";
    text = json['text'] ?? "";
    isFeatured = json['featured'] ?? false;
    if (json['links'] != null) {
      var links = json['links'];

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
/*   Map<String, String> _getLinkMap(dynamic jsonMap) {
    Map<String, String> resultM = Map<String, String>();
    if (jsonMap == null) {
      return resultM;
    }
    for (String key in jsonMap.keys) {
      resultM[key] = jsonMap[key];
    }

    return resultM;
  } */

  @override
  String toString() {
    return "Strike Point: Name $name, Place: $place, twitter $twitter, lon $lon | lat $lat";
  }
}
