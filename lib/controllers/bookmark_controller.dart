import 'package:get/get.dart';
import '../models/article_model.dart';
import '../models/bookmark_model.dart';
import '../services/storage_service.dart';
import '../services/analytics_service.dart';

class BookmarkController extends GetxController {
  final _storageService = StorageService();
  final _analyticsService = AnalyticsService();

  var bookmarks = <Bookmark>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    bookmarks.value = _storageService.getBookmarks();
  }

  void addBookmark(Article article) {
    if (_storageService.isBookmarked(article.id)) {
      Get.snackbar(
        'Info',
        'Artikel sudah disimpan sebelumnya',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _storageService.addBookmark(article);
    _analyticsService.trackBookmark();
    loadBookmarks();

    Get.snackbar(
      'Success',
      'Artikel berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteBookmark(String id) {
    _storageService.deleteBookmark(id);
    loadBookmarks();

    Get.snackbar(
      'Success',
      'Artikel dihapus dari bookmark',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void updateNote(String id, String note) {
    _storageService.updateNote(id, note);
    loadBookmarks();

    Get.snackbar(
      'Success',
      'Catatan berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  bool isBookmarked(String id) {
    return _storageService.isBookmarked(id);
  }

  Bookmark? getBookmark(String id) {
    return _storageService.getBookmark(id);
  }
}
