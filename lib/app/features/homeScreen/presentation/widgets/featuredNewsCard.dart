import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/controllers/bookmark_controller.dart';
import '../../../../core/domain/entities/article_entity.dart';
import 'SmartImage.dart';

class FeaturedNewsCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback? onTap;

  const FeaturedNewsCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 358,
        width: 468.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: SmartImage(
                        imageUrl: article.urlToImage ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.source.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${article.author ?? 'Unknown Author'} - ${article.publishedAt.split('T').first}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    child: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Newsreader',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: Text(
                      article.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          SharePlus.instance.share(
                            ShareParams(
                              text: 'Check out this article: ${article.title}\n\nRead more at: ${article.url}',
                            ),
                          );
                        },
                        child: const SizedBox(
                          width: 15,
                          height: 15,
                          child: Icon(
                            Icons.share,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ),
                      Obx(() {
                        final isBookmarked = bookmarkController.isBookmarked(article);
                        return GestureDetector(
                          onTap: () {
                            bookmarkController.toggleBookmark(article);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EDEC),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
                              color: isBookmarked ? const Color(0xFF1A237E) : Colors.black,
                              size: 15,
                            ),
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}