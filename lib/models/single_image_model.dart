// import 'package:flutter/material.dart';

class SingleImage {
  String id;
  String createdAt;
  String updatedAt;
  int width;
  int height;
  String color;
  int likes;
  bool likedByUser;
  String description;
  User user;
  List<CurrentUserCollections> currentUserCollections;
  Urls urls;
  Links links;

  SingleImage(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.width,
      this.height,
      this.color,
      this.likes,
      this.likedByUser,
      this.description,
      this.user,
      this.currentUserCollections,
      this.urls,
      this.links});

  SingleImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['current_user_collections'] != null) {
      currentUserCollections = new List<CurrentUserCollections>();
      json['current_user_collections'].forEach((v) {
        currentUserCollections.add(new CurrentUserCollections.fromJson(v));
      });
    }
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['width'] = this.width;
    data['height'] = this.height;
    data['color'] = this.color;
    data['likes'] = this.likes;
    data['liked_by_user'] = this.likedByUser;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.currentUserCollections != null) {
      data['current_user_collections'] =
          this.currentUserCollections.map((v) => v.toJson()).toList();
    }
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String username;
  String name;
  String portfolioUrl;
  String bio;
  String location;
  int totalLikes;
  int totalPhotos;
  int totalCollections;
  String instagramUsername;
  String twitterUsername;
  ProfileImage profileImage;
  Links links;

  User(
      {this.id,
      this.username,
      this.name,
      this.portfolioUrl,
      this.bio,
      this.location,
      this.totalLikes,
      this.totalPhotos,
      this.totalCollections,
      this.instagramUsername,
      this.twitterUsername,
      this.profileImage,
      this.links});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    portfolioUrl = json['portfolio_url'];
    bio = json['bio'];
    location = json['location'];
    totalLikes = json['total_likes'];
    totalPhotos = json['total_photos'];
    totalCollections = json['total_collections'];
    instagramUsername = json['instagram_username'];
    twitterUsername = json['twitter_username'];
    profileImage = json['profile_image'] != null
        ? new ProfileImage.fromJson(json['profile_image'])
        : null;
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['portfolio_url'] = this.portfolioUrl;
    data['bio'] = this.bio;
    data['location'] = this.location;
    data['total_likes'] = this.totalLikes;
    data['total_photos'] = this.totalPhotos;
    data['total_collections'] = this.totalCollections;
    data['instagram_username'] = this.instagramUsername;
    data['twitter_username'] = this.twitterUsername;
    if (this.profileImage != null) {
      data['profile_image'] = this.profileImage.toJson();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class ProfileImage {
  String small;
  String medium;
  String large;

  ProfileImage({this.small, this.medium, this.large});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['small'] = this.small;
    data['medium'] = this.medium;
    data['large'] = this.large;
    return data;
  }
}

class Links {
  String self;
  String html;
  String photos;
  String likes;
  String portfolio;

  Links({this.self, this.html, this.photos, this.likes, this.portfolio});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    html = json['html'];
    photos = json['photos'];
    likes = json['likes'];
    portfolio = json['portfolio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['self'] = this.self;
    data['html'] = this.html;
    data['photos'] = this.photos;
    data['likes'] = this.likes;
    data['portfolio'] = this.portfolio;
    return data;
  }
}

class CurrentUserCollections {
  int id;
  String title;
  String publishedAt;
  String updatedAt;
  bool curated;
  String coverPhoto;
  String user;

  CurrentUserCollections(
      {this.id,
      this.title,
      this.publishedAt,
      this.updatedAt,
      this.curated,
      this.coverPhoto,
      this.user});

  CurrentUserCollections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    publishedAt = json['published_at'];
    updatedAt = json['updated_at'];
    curated = json['curated'];
    coverPhoto = json['cover_photo'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['published_at'] = this.publishedAt;
    data['updated_at'] = this.updatedAt;
    data['curated'] = this.curated;
    data['cover_photo'] = this.coverPhoto;
    data['user'] = this.user;
    return data;
  }
}

class Urls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  Urls({this.raw, this.full, this.regular, this.small, this.thumb});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raw'] = this.raw;
    data['full'] = this.full;
    data['regular'] = this.regular;
    data['small'] = this.small;
    data['thumb'] = this.thumb;
    return data;
  }
}