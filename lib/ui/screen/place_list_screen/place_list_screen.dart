import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/constants/app_assets.dart';
import 'package:places/constants/app_constants.dart';
import 'package:places/constants/app_strings.dart';
import 'package:places/domain/filters_manager.dart';
import 'package:places/domain/model/location_point.dart';
import 'package:places/domain/model/place.dart';
import 'package:places/main.dart';
import 'package:places/ui/screen/place_card/place_view_card.dart';
import 'package:places/ui/screen/place_details_screen/place_details_bottom_sheet.dart';
import 'package:places/ui/screen/place_list.dart';
import 'package:places/ui/screen/place_list_screen/place_list_screen_sliver_app_bar.dart';
import 'package:places/ui/screen/res/routes.dart';
import 'package:places/ui/widget/gradient_extended_fab.dart';
import 'package:places/ui/widget/search_bar.dart';

/// Виджет, описывающий экран списка интересных мест
class PlaceListScreen extends StatefulWidget {
  static const String routeName = '/placeList';
  final FiltersManager filtersManager;

  const PlaceListScreen({
    required this.filtersManager,
    Key? key,
  }) : super(key: key);

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _requestForLocalPlaces();
    _requestForRemotePlaces();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    placeInteractor.disposePlacesStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GradientExtendedFab(
        icon: SvgPicture.asset(AppAssets.plusIcon),
        label: AppStrings.newPlaceTitle.toUpperCase(),
        startColor: colorScheme.surfaceVariant,
        endColor: colorScheme.secondary,
        onPressed: () {
          _openAddNewPlaceScreen(context);
        },
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        controller: _scrollController,
        headerSliverBuilder: (_, __) =>
            [PlaceListScreenSliverAppBar(scrollController: _scrollController)],
        body: Column(
          children: [
            const SizedBox(height: AppConstants.defaultPaddingX0_5),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: SearchBar(
                isBlocked: true,
                onOpenFiltersPressed: () {
                  _openFiltersScreen(context);
                },
                onTap: () {
                  _openSearchScreen(context);
                },
              ),
            ),
            const SizedBox(height: AppConstants.defaultPaddingX1_5),
            Expanded(
              child: StreamBuilder<List<Place>>(
                stream: placeInteractor.placesStream,
                builder: (context, snapshot) {
                  final places = snapshot.data;

                  if (snapshot.hasData && places != null && places.isNotEmpty) {
                    return PlaceList(
                      placeCards: places
                          .map((place) => PlaceViewCard(
                                place: place,
                                onFavoritePressed: () {
                                  placeInteractor.changeFavorite(place);
                                },
                                onCardTapped: () =>
                                    _openPlaceDetailsBottomSheet(
                                  context,
                                  place,
                                ),
                              ))
                          .toList(),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.secondary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Метод открытия окна детальной информации о месте
  Future<void> _openPlaceDetailsBottomSheet(
    BuildContext context,
    Place place,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).colorScheme.primary.withOpacity(0.24),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) {
        return PlaceDetailsBottomSheet(place: place);
      },
    );
    await _requestForLocalPlaces();
  }

  /// Метод открытия окна добавления нового места
  Future<void> _openAddNewPlaceScreen(
    BuildContext context,
  ) async {
    await AppRoutes.navigateToAddNewPlaceScreen(context: context);
    await _requestForRemotePlaces();
  }

  /// Метода открытия окна с фильтрами
  Future<void> _openFiltersScreen(
    BuildContext context,
  ) async {
    await AppRoutes.navigateToFiltersScreen(
      context: context,
      filtersManager: filtersManager,
    );
    await _requestForRemotePlaces();
  }

  /// Метода открытия окна поиска
  Future<void> _openSearchScreen(
    BuildContext context,
  ) async {
    await AppRoutes.navigateToSearchScreen(
      context: context,
      filtersManager: filtersManager,
    );
    await _requestForLocalPlaces();
  }

  /// Обновление списка мест из сети (временная мера пока нет стейтменеджмента)
  Future<void> _requestForRemotePlaces() async {
    await placeInteractor.requestPlaces(
      filtersManager: filtersManager,
      currentLocation: const LocationPoint(lat: 55.752881, lon: 37.604459),
    );
  }

  /// Обновление списка мест из локального списка (временная мера пока нет стейтменеджмента)
  Future<void> _requestForLocalPlaces() async {
    placeInteractor.requestLocalPlaces();
  }
}
