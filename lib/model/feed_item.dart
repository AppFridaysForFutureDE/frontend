class FeedItem {
  String imageUrl;

  String text;
  String cta;

  String link;
  bool inApp;

  FeedItem({this.imageUrl, this.link, this.inApp});

  FeedItem.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    text = json['text'];
    cta = json['cta'];
    link = json['link'];
    inApp = json['inApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['text'] = this.text;
    data['cta'] = this.cta;
    data['link'] = this.link;
    data['inApp'] = this.inApp;
    return data;
  }
}
