import 'package:flutter/material.dart';

import 'package:buffywalls/ui/common/common_export.dart';

class BuffyWallsModel {
  final List<String> titles;
  final List<String> proTitles;
  final List<PopularWall> popular;
  final List<String> trendingTags;
  final List<String> hotCollections;
  final List<int> hotCollectionIds;
  final List<int> topWallpapers;
  final List<Color> hotColors;
  final Banners banners;
  final List<AdBanner> adBanners;
  String error = "";

  BuffyWallsModel(
      {this.titles = const [AppStrings.buffyWallsTitle],
      this.proTitles = const [AppStrings.buffyWallsProTitle],
      this.trendingTags = const [],
      this.hotCollections = const [],
      this.hotCollectionIds = const [],
      this.topWallpapers = const [],
      this.hotColors = const [],
      this.popular = const [],
      this.banners = const Banners(),
      this.adBanners = const []});

  factory BuffyWallsModel.fromJson(Map<String, dynamic> json) =>
      BuffyWallsModel(
        adBanners: json['adBanners'] == null
            ? []
            : (json['adBanners'] as List<dynamic>)
                .map((v) => AdBanner.fromJson(v))
                .toList(),
        titles: json['titles'] == null
            ? []
            : (json['titles'] as List<dynamic>)
                .map((title) => title.toString())
                .toList(),
        proTitles: json['proTitles'] == null
            ? []
            : (json['proTitles'] as List<dynamic>)
                .map((title) => title.toString())
                .toList(),
        popular: json['popular'] == null
            ? []
            : (json['popular'] as List<dynamic>)
                .map((v) => PopularWall.fromJson(v))
                .toList(),
        banners: json['banners'] == null
            ? const Banners()
            : Banners.fromJson(json['banners']),
        trendingTags: json['trendingTags'] == null
            ? []
            : (json['trendingTags'] as List<dynamic>)
                .map((tag) => tag.toString())
                .toList(),
        hotCollections: json['hotCollections'] == null
            ? []
            : (json['hotCollections'] as List<dynamic>)
                .whereType<String>()
                .toList(),
        hotCollectionIds: json['hotCollections'] == null
            ? []
            : (json['hotCollections'] as List<dynamic>)
                .whereType<int>()
                .toList(),
        topWallpapers: json['topWallpapers'] == null
            ? []
            : (json['topWallpapers'] as List<dynamic>)
                .map((id) => id as int)
                .toList(),
        hotColors: json['hotColors'] == null
            ? []
            : (json['hotColors'] as List<dynamic>)
                .map((color) => color.toString().toLowerCase().toColor())
                .toList(),
      );

  @override
  String toString() => 'BuffyWallsModel(popular: $popular, error: $error)';
}

class Banners {
  final String free;
  final String paid;
  const Banners({
    this.free = '',
    this.paid = '',
  });

  factory Banners.fromJson(Map<String, dynamic> map) => Banners(
        free: map['free'] as String,
        paid: map['paid'] as String,
      );
}

class AdBanner {
  final int id;
  final String url;
  final String category;
  final String link;

  const AdBanner({
    this.id = 0,
    this.url = '',
    this.category = '',
    this.link = '',
  });

  factory AdBanner.fromJson(Map<String, dynamic> json) => AdBanner(
        id: json['id'] ?? 0,
        url: json['url'] ?? '',
        category: json['category'] ?? '',
        link: json['link'] ?? '',
      );
}

class PopularWall {
  int id;
  String name;
  String designer;
  String category;
  String imageUrl;
  String compressUrl;
  bool isPremium;
  bool isHot;
  List<String> tags;
  List<Color> colors;

  PopularWall({
    this.id = 0,
    this.name = '',
    this.designer = '',
    this.category = '',
    this.imageUrl = '',
    this.compressUrl = '',
    this.isHot = false,
    this.isPremium = false,
    this.tags = const [],
    this.colors = const [Colors.black],
  });

  factory PopularWall.fromJson(Map<String, dynamic> json) => PopularWall(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        designer: json['designer'] ?? '',
        category: json['category'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        compressUrl: json['compressUrl'] ?? '',
        isHot: json['isHot'] ?? false,
        isPremium: json['isPremium'] ?? false,
        tags: json['tags'] != null ? json['tags'].cast<String>() : [],
        colors: json['colors'] != null
            ? (json['colors'] as List<dynamic>)
                .map((color) => color.toString().toLowerCase().toColor())
                .toList()
            : [Colors.black],
      );

  @override
  String toString() {
    return 'PopularWall(id: $id, name: $name, designer: $designer, category: $category, imageUrl: $imageUrl, compressUrl: $compressUrl, isPremium: $isPremium, isHot: $isHot, tags: $tags, colors: $colors)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'designer': designer,
      'category': category,
      'imageUrl': imageUrl,
      'compressUrl': compressUrl,
      'isPremium': isPremium,
      'isHot': isHot,
      'tags': tags,
      'colors': colors.map((x) => x.value).toList(),
    };
  }
}
