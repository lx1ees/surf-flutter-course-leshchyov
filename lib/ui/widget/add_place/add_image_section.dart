import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:places/constants/app_constants.dart';
import 'package:places/ui/widget/add_place/new_image_card.dart';
import 'package:places/ui/widget/add_place/new_image_plus_card.dart';

/// Виджет-секция изображений [images] места с возможностью добавить и удалить изображение
/// посредством обработчиков [onAddImagePressed] и [onDeleteImagePressed]
class AddImageSection extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddImagePressed;
  final ValueChanged<int> onDeleteImagePressed;

  const AddImageSection({
    required this.images,
    required this.onAddImagePressed,
    required this.onDeleteImagePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.addNewPlaceImageSize,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: AppConstants.defaultPadding,
        ),
        children: [
          NewImagePlusCard(onPressed: onAddImagePressed),
          const SizedBox(width: AppConstants.defaultPadding),
          ...images
              .mapIndexed((index, path) => NewImageCard(
                    key: UniqueKey(),
                    path: path,
                    onDelete: () => onDeleteImagePressed(index),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
