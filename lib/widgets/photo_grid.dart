import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> photos;
  final Function(String) onImageTap;

  const PhotoGrid({
    super.key,
    required this.scrollController,
    required this.photos,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      controller: scrollController,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final imageUrl = photos[index];
        return GestureDetector(
          onTap: () => onImageTap(imageUrl),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
