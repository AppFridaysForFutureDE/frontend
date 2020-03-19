import 'dart:convert';
import 'dart:io';

import 'package:app/model/og.dart';
import 'package:app/model/post.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Definition: https://github.com/AppFridaysForFutureDE/backend/blob/master/swagger.yaml
class ApiService {
  http.Client client;

  // TODO Im Debug Mode auch durch den NodeJS-Endpunkt routen, sobald verfügbar
  final baseUrl = kReleaseMode
      ? 'https://app.fridaysforfuture.de/api/v1'
      : 'http://10.0.2.2:2368/ghost/api/v3/content';

  // Temporär, siehe oben
  // ! WICHTIG: Eigenen API Key definieren !
  final ghostApiKey = 'a80913c8c299b9dd96253b1763';

  ApiService() {
    client = http.Client();
  }

  // TODO Caching und Offline-Support hinzufügen

  Future<List<OG>> getOGs() async {
    var res = await client.get('$baseUrl/ogs');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return data.map<OG>((m) => OG.fromJson(m)).toList();
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  Future<List<Post>> getPosts() async {
    var res = await client.get(
        '$baseUrl/posts?include=authors,tags&fields=slug,id,title,feature_image,updated_at,published_at,url,excerpt,reading_time&key=$ghostApiKey');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return data['posts'].map<Post>((m) => Post.fromJson(m)).toList();
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  Future<Post> getPostById(String id) async {
    var res = await client.get('$baseUrl/posts/$id?fields=html');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return Post.fromJson(data['posts'].first);
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }
}
