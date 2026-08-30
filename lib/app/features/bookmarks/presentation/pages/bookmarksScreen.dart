import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/bookmark_controller.dart';
import '../../../../core/routes/appPageName.dart';
import '../../../homeScreen/presentation/widgets/LatestNewsCards.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        title: const Text(
          "Bookmarks",
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Get.offAllNamed(AppPageName.home),
          ),
        ],
      ),
      body: Obx(() {
        final bookmarks = bookmarkController.bookmarkedArticles;

        if (bookmarks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  "No bookmarked articles yet.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookmarks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final article = bookmarks[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppPageName.ArticleDetail, arguments: article);
              },
              child: LatestNewsCards(
                imageUrl: Rx(article.urlToImage ?? 'https://via.placeholder.com/150'),
                title: Rx(article.title),
                publishedAt: Rx(article.publishedAt),
                source: Rx(article.source.name),
                url: Rx(article.url),
                urlToImage: Rx(article.urlToImage ?? ''),
                author: Rx(article.author ?? ''),
                isFavorite: RxBool(true),
              ),
            );
          },
        );
      }),
    );
  }
}
