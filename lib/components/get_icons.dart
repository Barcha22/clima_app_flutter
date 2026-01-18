import 'package:flutter/material.dart';

class GetIconFromUrl extends StatelessWidget {
  final String url;
  final double size;
  final Color? color;

  const GetIconFromUrl({
    Key? key,
    required this.url,
    this.size = 160,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _customIconBuild();
    }

    String fullUrl = url;
    if (url.startsWith("//")) {
      fullUrl = "https:$url";
    }
    return Image.network(
      fullUrl, //
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
          ),
        );
      },
      errorBuilder: (context, error, StackTrace) {
        return _customIconBuild();
      },
    );
  }

  Widget _customIconBuild() {
    return Icon(
      _getCustomIcon(),
      size: 70,
      color: color ?? Colors.grey, //
    );
  }

  IconData _getCustomIcon() {
    return Icons.cloud;
  }
}
