import 'package:hive/hive.dart';
import '../models/app_usage_model.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static const String _boxName = 'app_usage';

  Box<AppUsage> get _box => Hive.box<AppUsage>(_boxName);

  AppUsage _getTodayUsage() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    var usage = _box.get(todayKey);
    if (usage == null) {
      usage = AppUsage(date: DateTime(today.year, today.month, today.day));
      _box.put(todayKey, usage);
    }
    return usage;
  }

  void trackAppOpen() {
    final usage = _getTodayUsage();
    usage.openCount++;
    usage.save();
  }

  void trackArticleRead(String category) {
    final usage = _getTodayUsage();
    usage.articlesRead++;
    usage.categoryReads[category] = (usage.categoryReads[category] ?? 0) + 1;
    usage.save();
  }

  void trackBookmark() {
    final usage = _getTodayUsage();
    usage.bookmarkCount++;
    usage.save();
  }

  int getTotalAppOpens() {
    return _box.values.fold(0, (sum, usage) => sum + usage.openCount);
  }

  int getTotalArticlesRead() {
    return _box.values.fold(0, (sum, usage) => sum + usage.articlesRead);
  }

  int getTotalBookmarks() {
    return _box.values.fold(0, (sum, usage) => sum + usage.bookmarkCount);
  }

  Map<String, int> getCategoryBreakdown() {
    final breakdown = <String, int>{};
    for (var usage in _box.values) {
      usage.categoryReads.forEach((category, count) {
        breakdown[category] = (breakdown[category] ?? 0) + count;
      });
    }
    return breakdown;
  }

  List<AppUsage> getLast7DaysUsage() {
    final now = DateTime.now();
    final usageList = <AppUsage>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      var usage = _box.get(key);

      if (usage == null) {
        usage = AppUsage(date: DateTime(date.year, date.month, date.day));
      }
      usageList.add(usage);
    }

    return usageList;
  }

  String? getFavoriteCategory() {
    final breakdown = getCategoryBreakdown();
    if (breakdown.isEmpty) return null;

    var maxCategory = breakdown.entries.first.key;
    var maxCount = breakdown.entries.first.value;

    for (var entry in breakdown.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        maxCategory = entry.key;
      }
    }

    return maxCategory;
  }

  int getDaysActive() {
    return _box.values.where((usage) => usage.articlesRead > 0).length;
  }
}
