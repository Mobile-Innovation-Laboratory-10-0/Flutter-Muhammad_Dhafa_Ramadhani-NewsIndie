import 'package:hive/hive.dart';
import '../models/article_model.dart';
import '../models/bookmark_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _boxName = 'bookmarks';

  Box<Bookmark> get _box => Hive.box<Bookmark>(_boxName);

  void addBookmark(Article article) {
    final bookmark = Bookmark(
      articleId: article.id,
      title: article.title,
      imageUrl: article.imageUrl,
      source: article.source,
      savedAt: DateTime.now(),
      description: article.description,
      url: article.url,
      category: article.category,
      publishedAt: article.publishedAt,
    );

    _box.put(article.id, bookmark);
  }

  List<Bookmark> getBookmarks() {
    final bookmarks = _box.values.toList();
    bookmarks.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return bookmarks;
  }

  Bookmark? getBookmark(String id) {
    return _box.get(id);
  }

  void updateNote(String id, String note) {
    final bookmark = _box.get(id);
    if (bookmark != null) {
      bookmark.personalNote = note;
      bookmark.save();
    }
  }

  void deleteBookmark(String id) {
    _box.delete(id);
  }

  bool isBookmarked(String id) {
    return _box.containsKey(id);
  }

  int getBookmarkCount() {
    return _box.length;
  }

  void clearAll() {
    _box.clear();
  }
}
