import 'package:conduit/models/profile.dart';

class Article {
  final String slug;
  final String title;
  final String description;
  final String body;
  final List<String> tagList;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorited;
  final int favoritesCount;
  final Profile author;

  Article({
    required this.slug,
    required this.title,
    required this.description,
    required this.body,
    required this.tagList,
    required this.createdAt,
    required this.updatedAt,
    required this.favorited,
    required this.favoritesCount,
    required this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      body: json['body'] ?? '',
      tagList: List<String>.from(json['tagList'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      favorited: json['favorited'] ?? false,
      favoritesCount: json['favoritesCount'] ?? 0,
      author: Profile.fromJson(json['author']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      'body': body,
      'tagList': tagList,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'favorited': favorited,
      'favoritesCount': favoritesCount,
      'author': author.toJson(),
    };
  }

  Article copyWith({
    String? slug,
    String? title,
    String? description,
    String? body,
    List<String>? tagList,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? favorited,
    int? favoritesCount,
    Profile? author,
  }) {
    return Article(
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      body: body ?? this.body,
      tagList: tagList ?? this.tagList,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favorited: favorited ?? this.favorited,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      author: author ?? this.author,
    );
  }
}
