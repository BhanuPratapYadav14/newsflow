import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  // Extracts the extension, ignoring query params like ?v=123
  String _getExtension(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return path.substring(dotIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _defaultError();
    }

    final extension = _getExtension(imageUrl);

    switch (extension) {
      case 'svg':
        return SvgPicture.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (context) =>
              placeholder ?? _defaultPlaceholder(),
        );

      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
      case 'gif':
        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ?? _defaultPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _defaultError();
          },
        );

      default:
        // Unknown extension — try Image.network as a fallback,
        // since some URLs don't carry an extension at all.
        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _defaultError();
          },
        );
    }
  }

  Widget _defaultPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _defaultError() {
    return SizedBox(
      width: width,
      height: height,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}