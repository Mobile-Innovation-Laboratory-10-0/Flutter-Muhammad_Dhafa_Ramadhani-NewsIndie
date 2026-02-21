import 'package:hive/hive.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject {
  @HiveField(0)
  String articleId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  String source;

  @HiveField(4)
  DateTime savedAt;

  @HiveField(5)
  String? personalNote;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? url;

  @HiveField(8)
  String category;

  @HiveField(9)
  DateTime publishedAt;

  Bookmark({
    required this.articleId,
    required this.title,
    this.imageUrl,
    required this.source,
    required this.savedAt,
    this.personalNote,
    this.description,
    this.url,
    this.category = 'general',
    required this.publishedAt,
  });
}
