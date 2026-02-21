import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/news_controller.dart';
import '../utils/constants.dart';
import '../widgets/category_chip.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_loading.dart';
import 'bookmark_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NewsController newsController = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'NEWSINDIE',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: AppColors.black),
            onPressed: () {
              Get.to(
                () => BookmarkPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryRow(),
          Expanded(
            child: Obx(() {
              if (newsController.isLoading.value &&
                  newsController.articles.isEmpty) {
                return _buildLoadingGrid();
              }

              if (newsController.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.newspaper,
                          size: 64, color: AppColors.silver),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada berita',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tarik ke bawah untuk refresh',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: newsController.refreshNews,
                color: AppColors.black,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: newsController.articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: newsController.articles[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Container(
      height: 60,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: AppCategories.categories.length,
        itemBuilder: (context, index) {
          final category = AppCategories.categories[index];
          return Obx(() => CategoryChip(
                category: category,
                isSelected: newsController.selectedCategory.value == category,
                onTap: () => newsController.changeCategory(category),
              ));
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerLoading(isCard: true),
    );
  }
}
