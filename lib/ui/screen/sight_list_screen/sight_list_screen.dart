import 'package:flutter/material.dart';
import 'package:places/constants/app_constants.dart';
import 'package:places/constants/app_strings.dart';
import 'package:places/constants/app_typography.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screen/custom_app_bar.dart';
import 'package:places/ui/screen/sight_card/sight_view_card.dart';
import 'package:places/ui/screen/sight_list.dart';

/// Виджет, описывающий экран списка интересных мест
class SightListScreen extends StatefulWidget {
  const SightListScreen({Key? key}) : super(key: key);

  @override
  State<SightListScreen> createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        child: Text(
          AppStrings.appBarTitle,
          style: AppTypography.appBarTitleTextStyle,
        ),
      ),
      body: SightList(
        sightCards: mocks.map((sight) => SightViewCard(sight: sight)).toList(),
      ),
    );
  }
}