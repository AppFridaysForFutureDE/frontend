class Author {
  String id;
  String name;
  String slug;
  String profileImage;
  String coverImage;
  String bio;
  String website;
  String location;
  String facebook;
  String twitter;
  String metaTitle;
  String metaDescription;
  String url;

  Author(
      {this.id,
      this.name,
      this.slug,
      this.profileImage,
      this.coverImage,
      this.bio,
      this.website,
      this.location,
      this.facebook,
      this.twitter,
      this.metaTitle,
      this.metaDescription,
      this.url});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    bio = json['bio'];
    website = json['website'];
    location = json['location'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['bio'] = this.bio;
    data['website'] = this.website;
    data['location'] = this.location;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['url'] = this.url;
    return data;
  }
}
