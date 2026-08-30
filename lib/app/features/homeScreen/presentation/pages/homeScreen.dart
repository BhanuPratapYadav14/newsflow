import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsflow/app/core/routes/appPageName.dart';

import '../../../../core/enums/newsCategoriesEnums.dart';
import '../controller/homeScreenController.dart';
import '../widgets/app_bar.dart';
import '../widgets/featuredNewsCard.dart';
import '../widgets/LatestNewsCards.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(onProfileTap: () {}, onSearchTap: () {}),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: controller.fetchNews,
            color: const Color(0xFF1A237E),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      alignment: Alignment.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: NewsCategory.values.length,
                        itemBuilder: (context, index) {
                          final category = NewsCategory.values[index];
                          final isSelected = controller.isSelected(category);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ChoiceChip(
                              selectedColor: isSelected ? const Color(0xFF1A237E) : Colors.grey[200],
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide.none,
                              ),
                              label: Text(
                                category.label,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => controller.selectCategory(category),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Featured",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppPageName.newsList);
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SizedBox(
                          height: 358,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        );
                      }

                      final featured = controller.featuredArticle.value;
                      if (featured == null) {
                        return const SizedBox(
                          height: 358,
                          child: Center(
                            child: Text("No featured article available"),
                          ),
                        );
                      }

                      return FeaturedNewsCard(
                        article: featured,
                        onTap: () {
                          Get.toNamed(AppPageName.ArticleDetail, arguments: featured);
                        },
                      );
                    }),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Latest News",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppPageName.newsList, arguments: 'latest');
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1A237E),
                          ),
                        );
                      }

                      final latest = controller.latestArticles;

                      if (latest.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text("No latest news available for today"),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          shrinkWrap: true, // Crucial: Sizes the list to its children
                          physics: const NeverScrollableScrollPhysics(), // Crucial: Disables nested scrolling
                          itemCount: latest.length,
                          itemBuilder: (context, index) {
                            final article = latest[index];
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
                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}