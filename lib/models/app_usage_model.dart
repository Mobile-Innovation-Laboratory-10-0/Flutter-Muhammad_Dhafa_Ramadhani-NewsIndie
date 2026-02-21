import 'package:hive/hive.dart';

part 'app_usage_model.g.dart';

@HiveType(typeId: 1)
class AppUsage extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int openCount;

  @HiveField(2)
  int articlesRead;

  @HiveField(3)
  Map<String, int> categoryReads;

  @HiveField(4)
  int bookmarkCount;

  AppUsage({
    required this.date,
    this.openCount = 0,
    this.articlesRead = 0,
    Map<String, int>? categoryReads,
    this.bookmarkCount = 0,
  }) : categoryReads = categoryReads ?? {};
}
