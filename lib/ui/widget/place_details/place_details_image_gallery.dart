import 'package:flutter/material.dart';
import 'package:places/ui/widget/common/gallery_indicator.dart';
import 'package:places/ui/widget/common/image_placeholder.dart';
import 'package:places/ui/widget/place_details/indicator_line.dart';

/// Виджет для отображения галереи достопримечательности
class PlaceDetailsImageGallery extends StatefulWidget {
  final List<String> urls;

  const PlaceDetailsImageGallery({
    this.urls = const [],
    Key? key,
  }) : super(key: key);

  @override
  State<PlaceDetailsImageGallery> createState() =>
      _PlaceDetailsImageGalleryState();
}

class _PlaceDetailsImageGalleryState extends State<PlaceDetailsImageGallery> {
  final PageController _pageController = PageController();
  double _indicatorWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        /// Вычисляем ширину индикатора один раз при отрисовке первого кадра
        _indicatorWidth = _calculateIndicatorWidth(
          context: context,
          imagesCount: widget.urls.length,
        );
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: widget.urls.isNotEmpty
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.urls.length,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: widget.urls[0],
                      child: Image.network(
                        widget.urls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const ImagePlaceholder();
                        },
                        loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: IndicatorLine(
                    indicator: GalleryIndicator(
                      width: _indicatorWidth,
                    ),
                    numberOfSegments:
                        widget.urls.isNotEmpty ? widget.urls.length : 1,
                    scrollController: _pageController,
                  ),
                ),
              ],
            )
          : const ImagePlaceholder(),
    );
  }

  /// Метод для вычисления ширины индикатора на основе ширины экрана и
  /// количества фото в галереи [imagesCount]
  double _calculateIndicatorWidth({
    required BuildContext context,
    required int imagesCount,
  }) {
    final imagesCountResolved = imagesCount != 0 ? imagesCount : 1;

    return MediaQuery.of(context).size.width / imagesCountResolved;
  }
}
