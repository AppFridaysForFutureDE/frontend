import 'package:app/model/banner.dart';
import 'package:app/model/feed_item.dart';

class HomePageData {
  Banner banner;
  List<FeedItem> feed;

  HomePageData({this.banner, this.feed});

  HomePageData.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    if (json['feed'] != null) {
      feed = new List<FeedItem>();
      json['feed'].forEach((v) {
        feed.add(new FeedItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    if (this.feed != null) {
      data['feed'] = this.feed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}