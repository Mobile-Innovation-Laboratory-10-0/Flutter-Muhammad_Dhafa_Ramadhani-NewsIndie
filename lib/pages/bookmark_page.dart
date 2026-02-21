import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/bookmark_controller.dart';
import '../models/article_model.dart';
import '../models/bookmark_model.dart';
import '../utils/constants.dart';
import '../widgets/empty_state.dart';
import 'detail_page.dart';

class BookmarkPage extends StatelessWidget {
  BookmarkPage({super.key});

  final BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Saved Articles',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (bookmarkController.bookmarks.isEmpty) {
          return const EmptyState(
            icon: Icons.bookmark_border,
            message: 'Belum ada artikel tersimpan',
            subtitle: 'Bookmark artikel favorit Anda untuk dibaca nanti',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookmarkController.bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarkController.bookmarks[index];
            return _buildBookmarkItem(bookmark);
          },
        );
      }),
    );
  }

  Widget _buildBookmarkItem(Bookmark bookmark) {
    return Dismissible(
      key: Key(bookmark.articleId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: AppColors.white, size: 28),
      ),
      onDismissed: (direction) {
        bookmarkController.deleteBookmark(bookmark.articleId);
      },
      child: GestureDetector(
        onTap: () {
          final article = Article(
            id: bookmark.articleId,
            title: bookmark.title,
            description: bookmark.description,
            imageUrl: bookmark.imageUrl,
            source: bookmark.source,
            category: bookmark.category,
            publishedAt: bookmark.publishedAt,
            url: bookmark.url,
          );

          Get.to(
            () => DetailPage(article: article),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [newspaperShadow],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
                child: CachedNetworkImage(
                  imageUrl: bookmark.imageUrl ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.silver,
                    child: const Icon(Icons.image,
                        color: AppColors.gray, size: 32),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        color: AppColors.black,
                        child: Text(
                          bookmark.category.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bookmark.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${bookmark.source} • ${timeago.format(bookmark.publishedAt, locale: 'id')}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.lightGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (bookmark.personalNote != null &&
                          bookmark.personalNote!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.note,
                                size: 12, color: AppColors.gray),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                bookmark.personalNote!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.gray,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.gray),
                color: AppColors.white,
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditNoteDialog(bookmark);
                  } else if (value == 'delete') {
                    bookmarkController.deleteBookmark(bookmark.articleId);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit,
                            size: 18, color: AppColors.black),
                        const SizedBox(width: 12),
                        Text(
                          'Edit Catatan',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete,
                            size: 18, color: AppColors.black),
                        const SizedBox(width: 12),
                        Text(
                          'Hapus',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
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

  void _showEditNoteDialog(Bookmark bookmark) {
    final controller = TextEditingController(text: bookmark.personalNote ?? '');

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
                'Edit Catatan',
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
                autofocus: true,
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
                      bookmarkController.updateNote(
                          bookmark.articleId, controller.text);
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
}
