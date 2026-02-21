import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class NewsController extends GetxController {
  final _apiService = ApiService();

  var articles = <Article>[].obs;
  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService.init();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final category = AppCategories.getCategoryParam(selectedCategory.value);
      final fetchedArticles = await _apiService.fetchNews(
        category: category.isEmpty ? null : category,
      );

      articles.value = fetchedArticles;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat berita: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      fetchNews();
    }
  }

  Future<void> refreshNews() async {
    await fetchNews();
  }
}
