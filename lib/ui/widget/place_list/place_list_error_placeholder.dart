import 'package:flutter/material.dart';
import 'package:places/constants/app_assets.dart';
import 'package:places/constants/app_strings.dart';
import 'package:places/ui/widget/common/no_items_placeholder.dart';

/// Виджет-плейсхолдер в случае ошибки при получении списка мест
class PlaceListErrorPlaceholder extends StatelessWidget {
  const PlaceListErrorPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NoItemsPlaceholder(
      title: AppStrings.error,
      subtitle: AppStrings.errorSomethingWentWrong,
      iconPath: AppAssets.errorIcon,
    );
  }
}
