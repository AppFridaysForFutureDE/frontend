class Banner {
  String imageUrl;
  String link;
  bool inApp;

  Banner({this.imageUrl, this.link, this.inApp});

  Banner.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    link = json['link'];
    inApp = json['inApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['link'] = this.link;
    data['inApp'] = this.inApp;
    return data;
  }
}
