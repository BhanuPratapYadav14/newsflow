import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/appPageName.dart';
import '../../../homeScreen/presentation/widgets/featuredNewsCard.dart';
import '../controller/searchController.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsSearchController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Search Articles",
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: controller.searchTextController,
              decoration: InputDecoration(
                hintText: "Search by keyword, category, or source...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1A237E)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: controller.clearSearch,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.performSearch(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1A237E),
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                if (controller.query.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Search the latest news and stories",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No results found for '${controller.query.value}'",
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.searchResults.length,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final article = controller.searchResults[index];
                  return FeaturedNewsCard(
                    article: article,
                    onTap: () {
                      Get.toNamed(AppPageName.ArticleDetail, arguments: article);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
