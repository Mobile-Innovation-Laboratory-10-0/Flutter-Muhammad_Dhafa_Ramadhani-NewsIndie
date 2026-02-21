import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/article_model.dart';
import '../controllers/bookmark_controller.dart';
import '../services/analytics_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class DetailPage extends StatelessWidget {
  final Article article;

  DetailPage({
    super.key,
    required this.article,
  });

  final BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    AnalyticsService().trackArticleRead(article.category);
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.black),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: AppColors.black),
                ),
                onPressed: () {
                  Share.share(
                    '${article.title}\n\n${article.url ?? 'NewsIndie App'}',
                    subject: article.title,
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'article_${article.id}',
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.silver,
                    child: const Icon(Icons.image,
                        size: 64, color: AppColors.gray),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: AppColors.black,
                    child: Text(
                      article.category.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGray,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeago.format(article.publishedAt, locale: 'id'),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.lightGray,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGray,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Helpers.calculateReadTime(article.description),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                    thickness: 1,
                    color: AppColors.silver,
                  ),
                  if (article.description != null &&
                      article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.darkGray,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (article.url != null && article.url!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _launchUrl(article.url!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.black,
                          side: const BorderSide(
                              color: AppColors.black, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: Text(
                          'BACA SELENGKAPNYA',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Obx(() {
                    bookmarkController.bookmarks.length;
                    final bookmark = bookmarkController.getBookmark(article.id);

                    if (bookmark != null &&
                        bookmark.personalNote != null &&
                        bookmark.personalNote!.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.silver, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.note,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Catatan Pribadi',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showNoteDialog(),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                bookmark.personalNote!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.darkGray,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [floatShadow],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Obx(() {
              final isBookmarked = bookmarkController.isBookmarked(article.id);
              bookmarkController.bookmarks.length;
              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.black,
                  size: 28,
                ),
                onPressed: () {
                  if (isBookmarked) {
                    bookmarkController.deleteBookmark(article.id);
                  } else {
                    bookmarkController.addBookmark(article);
                  }
                },
              );
            }),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showNoteDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                icon: const Icon(Icons.edit_note, size: 20),
                label: Flexible(
                  child: Text(
                    'TAMBAH CATATAN',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDialog() {
    final bookmark = bookmarkController.getBookmark(article.id);
    final controller =
        TextEditingController(text: bookmark?.personalNote ?? '');

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan Pribadi',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tulis catatan Anda di sini...',
                  hintStyle: GoogleFonts.inter(color: AppColors.lightGray),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.silver),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.black),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'BATAL',
                      style: GoogleFonts.inter(
                        color: AppColors.gray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (bookmark == null) {
                        bookmarkController.addBookmark(article);
                      }
                      bookmarkController.updateNote(
                          article.id, controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      'SIMPAN',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
