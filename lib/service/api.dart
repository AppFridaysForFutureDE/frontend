import 'dart:convert';
import 'dart:io';

import 'package:app/model/og.dart';
import 'package:app/model/post.dart';
import 'package:http/http.dart' as http;

/// Definition: https://github.com/AppFridaysForFutureDE/backend/blob/master/swagger.yaml
class ApiService {
  http.Client client;
  final baseUrl = 'https://app.fridaysforfuture.de/api/v1';

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
        '$baseUrl/posts?include=authors,tags&fields=slug,id,title,feature_image,updated_at,published_at,url,excerpt,reading_time');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return data.map<Post>((m) => Post.fromJson(m)).toList();
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  Future<Post> getPostById(String id) async {
    var res = await client.get('$baseUrl/posts/$id?fields=html');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return Post.fromJson(data);
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }
}
