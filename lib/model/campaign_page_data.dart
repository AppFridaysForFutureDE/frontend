import 'package:app/model/banner.dart';
import 'package:app/model/campaign.dart';

class CampaignPageData {
  List<Banner> banners;
  List<Campaign> campaigns;

  CampaignPageData({this.banners, this.campaigns});

  CampaignPageData.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = new List<Banner>();
      json['banners'].forEach((v) {
        banners.add(new Banner.fromJson(v));
      });
    }
    if (json['campaigns'] != null) {
      campaigns = new List<Campaign>();
      json['campaigns'].forEach((v) {
        campaigns.add(new Campaign.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    if (this.campaigns != null) {
      data['campaigns'] = this.campaigns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}