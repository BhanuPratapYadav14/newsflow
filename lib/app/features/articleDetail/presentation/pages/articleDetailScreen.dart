import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/controllers/bookmark_controller.dart';
import '../../../../core/routes/appPageName.dart';
import '../controller/articleDetailController.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ArticleDetailController>();
    
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView resource error: ${error.description}");
          },
        ),
      );

    if (controller.article.url.isNotEmpty) {
      _webViewController.loadRequest(Uri.parse(controller.article.url));
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ArticleDetailController>();
    final article = controller.article;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          article.source.name,
          style: const TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF1A237E)),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: 'Check out this article: ${article.title}\n\nRead more at: ${article.url}',
                ),
              );
            },
          ),
          Obx(() {
            final bookmarkController = Get.find<BookmarkController>();
            final isBookmarked = bookmarkController.isBookmarked(article);
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: const Color(0xFF1A237E),
              ),
              onPressed: () {
                bookmarkController.toggleBookmark(article);
              },
            );
          }),
          // IconButton(
          //   icon: const Icon(Icons.home, color: Color(0xFF1A237E)),
          //   onPressed: () => Get.offAllNamed(AppPageName.home),
          // ),
        ],
      ),
      body: article.url.isEmpty
          ? const Center(child: Text("No URL available for this article"))
          : Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A237E),
                    ),
                  ),
              ],
            ),
    );
  }
}
