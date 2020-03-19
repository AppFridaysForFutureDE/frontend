
class Tag {
  String id;
  String name;
  String slug;
  String description;
  String featureImage;
  String visibility;
  String metaTitle;
  String metaDescription;
  String url;

  Tag(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.featureImage,
      this.visibility,
      this.metaTitle,
      this.metaDescription,
      this.url});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    featureImage = json['feature_image'];
    visibility = json['visibility'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['feature_image'] = this.featureImage;
    data['visibility'] = this.visibility;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['url'] = this.url;
    return data;
  }
}