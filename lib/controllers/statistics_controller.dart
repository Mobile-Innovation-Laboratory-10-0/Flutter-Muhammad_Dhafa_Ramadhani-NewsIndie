import 'package:get/get.dart';
import '../services/analytics_service.dart';
import '../models/app_usage_model.dart';

class StatisticsController extends GetxController {
  final _analyticsService = AnalyticsService();

  var totalAppOpens = 0.obs;
  var totalArticlesRead = 0.obs;
  var totalBookmarks = 0.obs;
  var daysActive = 0.obs;
  var favoriteCategory = ''.obs;
  var categoryBreakdown = <String, int>{}.obs;
  var last7DaysUsage = <AppUsage>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  void loadStatistics() {
    totalAppOpens.value = _analyticsService.getTotalAppOpens();
    totalArticlesRead.value = _analyticsService.getTotalArticlesRead();
    totalBookmarks.value = _analyticsService.getTotalBookmarks();
    daysActive.value = _analyticsService.getDaysActive();
    favoriteCategory.value =
        _analyticsService.getFavoriteCategory() ?? 'Belum ada';
    categoryBreakdown.value = _analyticsService.getCategoryBreakdown();
    last7DaysUsage.value = _analyticsService.getLast7DaysUsage();
  }

  void refreshStatistics() {
    loadStatistics();
  }
}
