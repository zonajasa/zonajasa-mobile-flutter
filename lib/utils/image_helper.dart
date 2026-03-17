import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jasa_app/model/app_colors.dart';

/// A helper class to handle image loading across different platforms
/// and provide consistent error handling and loading placeholders
class ImageHelper {
  /// Loads a network image with proper caching and error handling
  static Widget loadImage({
    required String path,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    final defaultPlaceholder = Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );

    final defaultErrorWidget = Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.grey,
      ),
    );

    final isNetwork = path.startsWith('http');

    // 🔥 kalau asset
    if (!isNetwork) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(path, width: width, height: height, fit: fit),
      );
    }

    // 🔥 kalau network
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return placeholder ?? defaultPlaceholder;
          },
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? defaultErrorWidget;
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? defaultPlaceholder,
        errorWidget: (context, url, error) => errorWidget ?? defaultErrorWidget,
      ),
    );
  }
}
