import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/bookmark_controller.dart';
import 'SmartImage.dart';

class LatestNewsCards extends StatelessWidget {
  final Rx<String> imageUrl;
  final Rx<String> title;
  final Rx<String> publishedAt;
  final Rx<String> source;
  final Rx<String> url;
  final Rx<String> urlToImage;
  final Rx<String> author;
  final RxBool isFavorite;

  const LatestNewsCards({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.publishedAt,
    required this.source,
    required this.url,
    required this.urlToImage,
    required this.author,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();

    return Obx(() {
      final isBookmarked = bookmarkController.isBookmarkedByUrl(url.value);

      return Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: SmartImage(
                  imageUrl: imageUrl.value.isNotEmpty ? imageUrl.value : urlToImage.value,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          source.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF1A237E),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            bookmarkController.toggleBookmarkByFields(
                              url: url.value,
                              title: title.value,
                              sourceName: source.value,
                              urlToImage: urlToImage.value.isNotEmpty ? urlToImage.value : imageUrl.value,
                              publishedAt: publishedAt.value,
                              author: author.value,
                            );
                          },
                          child: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            size: 18,
                            color: isBookmarked ? const Color(0xFF1A237E) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        title.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                          fontFamily: 'Newsreader',
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${author.value.isNotEmpty ? '${author.value} • ' : ''}${publishedAt.value.split('T').first}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}