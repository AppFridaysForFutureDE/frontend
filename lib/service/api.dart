import 'dart:convert';
import 'dart:io';

import 'package:app/model/campaign.dart';
import 'package:app/model/home_page_data.dart';
import 'package:app/model/live_event.dart';
import 'package:app/model/slogan.dart';
import 'package:app/model/strike.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:app/model/og.dart';
import 'package:app/model/post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import 'package:path_provider/path_provider.dart';

import 'cache.dart';

const feedCategories = const ['Wissenschaft', 'Intern', 'Politik'];

/// Definition: https://github.com/AppFridaysForFutureDE/backend/blob/master/swagger.yaml
class ApiService {
  http.Client client;

  String baseUrl;
  String ghostBaseUrl;
  String ghostApiKey;

  CacheService cache;

  ApiService() {
    client = http.Client();
  }

  loadConfig() async {
    var doc = loadYaml(await rootBundle.loadString('assets/config.yaml'));

    baseUrl = doc['baseUrl'];
    ghostBaseUrl = doc['ghostBaseUrl'];
    ghostApiKey = doc['ghostApiKey'];

    cache = CacheService(await getTemporaryDirectory());
  }

  Future<HomePageData> getHomePageData() async {
    try {
      var res = await client.get('$baseUrl/home');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('home.json', res.body);

        var data = json.decode(utf8.decode(res.bodyBytes));
        return HomePageData.fromJson(data);
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('home.json')) {
        var data = json.decode(cache.get('home.json'));
        return HomePageData.fromJson(data);
      } else {
        throw Exception('Home Page Data not available online or in cache');
      }
    }
  }

  Future<List<OG>> getOGs() async {
    try {
      var res = await client.get('$baseUrl/ogs');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('ogs.json', res.body);

        var data = json.decode(res.body);
        return data['ogs'].map<OG>((m) => OG.fromJson(m)).toList();
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('ogs.json')) {
        var data = json.decode(cache.get('ogs.json'));
        return data['ogs'].map<OG>((m) => OG.fromJson(m)).toList();
      } else {
        throw Exception('OG List not available online or in cache');
      }
    }
  }

  Future<OG> getOGbyId(String id) async {
    var res = await client.get('$baseUrl/ogs?ogId=$id');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);

      if (data['count'] == 0) {
        return null;
      }
      return OG.fromJson(data['ogs'][0]);
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  Future<List<Strike>> getStrikesByOG(String ogId) async {
    var res = await client.get('$baseUrl/strikes?ogId=$ogId');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      return data['strikes'].map<Strike>((m) => Strike.fromJson(m)).toList();
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      var res = await client.get(
          '$ghostBaseUrl/content/posts?include=authors,tags&fields=slug,id,title,feature_image,updated_at,published_at,url,custom_excerpt&key=$ghostApiKey&limit=30'); // TODO Better pagination

      if (res.statusCode == HttpStatus.ok) {
        cache.put('posts.json', res.body);

        var data = json.decode(res.body);
        return data['posts'].map<Post>((m) => Post.fromJson(m)).toList();
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('posts.json')) {
        var data = json.decode(cache.get('posts.json'));
        return data['posts'].map<Post>((m) => Post.fromJson(m)).toList();
      } else {
        throw Exception('Post List not available online or in cache');
      }
    }
  }

  Future<List<Slogan>> getSlogans() async {
    try {
      var res = await client.get('$baseUrl/slogans');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('slogans.json', res.body);

        var data = json.decode((res.body));
        return data['slogans'].map<Slogan>((m) => Slogan.fromJson(m)).toList();
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('slogans.json')) {
        var data = json.decode(cache.get('slogans.json'));
        return data['slogans'].map<Slogan>((m) => Slogan.fromJson(m)).toList();
      } else {
        throw Exception('Slogan List not available online or in cache');
      }
    }
  }


  Future<Post> getPostById(String id, {bool metadata = false}) async {
    try {
      var res = await client.get(
          '$ghostBaseUrl/content/posts/$id${metadata ? '?include=authors,tags&fields=slug,id,title,feature_image,updated_at,published_at,url,custom_excerpt' : '?fields=html'}&key=$ghostApiKey');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('post/$id.json', res.body);

        var data = json.decode(res.body);
        return Post.fromJson(data['posts'].first);
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('post/$id.json')) {
        var data = json.decode(cache.get('post/$id.json'));
        return Post.fromJson(data['posts'].first);
      } else {
        throw Exception('Post not available online or in cache');
      }
    }
  }

  /*
   * Takes the Slug of a Page and returns the Title.
   * or throws a Http Status Exception if no matching Article found.
   */
  Future<String> getPageTitleBySlug(String name) async {
    var res = await client.get(
        '$ghostBaseUrl/content/pages/slug/$name?fields=title&key=$ghostApiKey');

    if (res.statusCode == HttpStatus.ok) {
      var data = json.decode(res.body);
      Post post = Post.fromJson(data['pages'].first);
      return post.title;
    } else {
      throw Exception('HTTP Status ${res.statusCode}');
    }
  }

  /*
   * Takes a SLUG from a Ghost Page and returns the Page with only slug and html and the ID
   * or throws a HTTP Status exception if there is no matching article in the backend
   */

  Future<Post> getPageBySlug(String name) async {
    try {
      var res = await client.get(
          '$ghostBaseUrl/content/pages/slug/$name?fields=html&key=$ghostApiKey');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('page/$name.json', res.body);

        var data = json.decode(res.body);
        return Post.fromJson(data['pages'].first);
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('page/$name.json')) {
        var data = json.decode(cache.get('page/$name.json'));
        return Post.fromJson(data['pages'].first);
      } else {
        throw Exception('Post not available online or in cache');
      }
    }
  }

  Future updateOGs() async {
    if (!(Hive.box('data').get('firstStart') ?? true)) {
      print("Updating OG");
      await Future.delayed(Duration(seconds: 5));

      for (String id in Hive.box('subscribed_ogs').keys) {
        getOGbyId(id).then((og) {
          if (og == null) {
            Hive.box('subscribed_ogs').delete(id);
            FirebaseMessaging().unsubscribeFromTopic('og_${og.ogId}');
          } else {
            Hive.box('subscribed_ogs').put(id, og);
          }
        }).catchError((e) {});
      }
    }
  }

  /**
   * Fetches a Liveevent from the Servers. A live event gets also returned if no event is live.
   * In this case a Event with isLive == false
   * A a exception is thrown.
   */
  Future<LiveEvent> getLiveEvent() async {
    //DEBUG data: first true if a live event is active
    // second true if the banner schould open the first netzstrike action or the Url
    // 3th the title
    // 4th the url which schould be displayed if inApp == false
    //return LiveEvent(true,true, "Jetzt Live: PCS Livestream", "https://fridaysforfuture.org");
    try {
      var res = await client.get('$baseUrl/liveevent?liveeventId=0');

      if (res.statusCode == HttpStatus.ok) {
        var data = json.decode(res.body);
        LiveEvent event = LiveEvent.fromJSON(data['liveevent']);
        return event;
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      print("Could not load the liveevent data");
      return LiveEvent(false, false, null, null);
      //throw Exception('Could not load the live Event Data');
    }
  }

  // TODO: also retrieve banners from json
  Future<List<Campaign>> getCampaigns() async {
    try {
      var res = await client.get('$baseUrl/campaigns');

      if (res.statusCode == HttpStatus.ok) {
        cache.put('campaigns.json', res.body);

        var data = json.decode(utf8.decode(res.bodyBytes));
        return data['campaigns']
            .map<Campaign>((m) => Campaign.fromJson(m))
            .toList();
      } else {
        throw Exception('HTTP Status ${res.statusCode}');
      }
    } catch (e) {
      if (cache.exists('campaigns.json')) {
        var data = json.decode(cache.get('campaigns.json'));
        return data['campaigns']
            .map<Campaign>((m) => Campaign.fromJson(m))
            .toList();
      } else {
        throw Exception('Campaign List not available online or in cache');
      }
    }
  }
}
