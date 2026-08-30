import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/appPageName.dart';
import '../../../homeScreen/presentation/widgets/LatestNewsCards.dart';
import '../controller/newsListController.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsListController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Obx(() => Text(
              "${controller.mode.value == 'latest' ? 'Latest' : 'Featured'} ${controller.categoryLabel} News",
              style: const TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.home),
        //     onPressed: () => Get.offAllNamed(AppPageName.home),
        //   ),
        // ],
      ),
      body: Obx(() {
        final articles = controller.articlesList;

        if (controller.isLoading && articles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1A237E),
            ),
          );
        }

        if (articles.isEmpty) {
          return const Center(
            child: Text("No news articles found"),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          color: const Color(0xFF1A237E),
          child: ListView.separated(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: articles.length + (controller.hasMore.value ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == articles.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A237E),
                      strokeWidth: 2.0,
                    ),
                  ),
                );
              }

              final article = articles[index];
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
                  isFavorite: RxBool(false),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
