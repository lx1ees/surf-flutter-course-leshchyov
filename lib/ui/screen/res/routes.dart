import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places/domain/model/location_point.dart';
import 'package:places/domain/model/place.dart';
import 'package:places/domain/model/place_type.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen_widget_model.dart';
import 'package:places/ui/screen/filters_screen/filters_screen.dart';
import 'package:places/ui/screen/filters_screen/filters_screen_widget_model.dart';
import 'package:places/ui/screen/home_screen/home_screen.dart';
import 'package:places/ui/screen/map_screen/map_screen.dart';
import 'package:places/ui/screen/map_screen/map_screen_widget_model.dart';
import 'package:places/ui/screen/onboarding_screen/onboarding_screen.dart';
import 'package:places/ui/screen/onboarding_screen/onboarding_screen_widget_model.dart';
import 'package:places/ui/screen/place_details_screen/place_details_screen.dart';
import 'package:places/ui/screen/place_details_screen/place_details_screen_widget_model.dart';
import 'package:places/ui/screen/place_list_screen/place_list_screen.dart';
import 'package:places/ui/screen/place_list_screen/place_list_screen_widget_model.dart';
import 'package:places/ui/screen/place_search_screen/place_search_screen.dart';
import 'package:places/ui/screen/place_search_screen/place_search_screen_widget_model.dart';
import 'package:places/ui/screen/settings_screen/settings_screen.dart';
import 'package:places/ui/screen/settings_screen/settings_screen_widget_model.dart';
import 'package:places/ui/screen/splash_screen/splash_screen.dart';
import 'package:places/ui/screen/splash_screen/splash_screen_widget_model.dart';
import 'package:places/ui/screen/visiting_screen/visiting_screen.dart';
import 'package:places/ui/screen/visiting_screen/visiting_screen_widget_model.dart';
import 'package:places/ui/widget/add_place/select_geolocation.dart';
import 'package:places/ui/widget/add_place/select_place_type.dart';

/// Класс роутинга
abstract class AppRoutes {
  static const String mainNavigatorKey = 'mainNavigatorKey';
  static const String bottomNavigatorKey = 'bottomNavigatorKey';

  static final Map<String, GlobalKey<NavigatorState>> navigators = {
    /// Этим навигатором обрабатываются все роуты кроме тех, что в BottomNavigationBar
    mainNavigatorKey: GlobalKey<NavigatorState>(),

    /// Этим навигатором обрабатываются роуты, находящиеся в BottomNavigationBar
    bottomNavigatorKey: GlobalKey<NavigatorState>(),
  };

  static final Map<String, Widget Function(BuildContext context)>
      bottomNavigationRoutes = {
    PlaceListScreen.routeName: (context) => const PlaceListScreen(
          widgetModelFactory: placeListScreenWidgetModelFactory,
        ),
    MapScreen.routeName: (context) => const MapScreen(
          widgetModelFactory: mapScreenWidgetModelFactory,
        ),
    VisitingScreen.routeName: (_) => const VisitingScreen(
          widgetModelFactory: visitingScreenWidgetModelFactory,
        ),
    SettingsScreen.routeName: (context) => const SettingsScreen(
          widgetModelFactory: settingsScreenWidgetModelFactory,
        ),
  };

  static final Map<String, Widget Function(Object? argument)>
      _mainNavigationRoutes = {
    SplashScreen.routeName: (_) => const SplashScreen(
          widgetModelFactory: splashScreenWidgetModelFactory,
        ),
    HomeScreen.routeName: (_) => const HomeScreen(),
    AddPlaceScreen.routeName: (_) => const AddPlaceScreen(
          widgetModelFactory: addPlaceScreenWidgetModelFactory,
        ),
    OnboardingScreen.routeName: (argument) {
      final fromLaunch = argument as bool;

      return OnboardingScreen(
        widgetModelFactory: onboardingScreenWidgetModelFactory,
        fromLaunch: fromLaunch,
      );
    },
    SelectPlaceTypeScreen.routeName: (argument) {
      final selectedPlaceType = argument as PlaceType?;

      return SelectPlaceTypeScreen(selectedPlaceType: selectedPlaceType);
    },
    SelectGeolocationScreen.routeName: (argument) {
      final selectedGeolocation = argument as LocationPoint?;

      return SelectGeolocationScreen(
        selectedLocationPoint: selectedGeolocation,
      );
    },
    FiltersScreen.routeName: (argument) {
      return const FiltersScreen(
        widgetModelFactory: filtersScreenWidgetModelFactory,
      );
    },
    PlaceDetailsScreen.routeName: (argument) {
      final args = argument as Place;

      return PlaceDetailsScreen(
        place: args,
        widgetModelFactory: placeDetailsScreenWidgetModelFactory,
      );
    },
    PlaceSearchScreen.routeName: (argument) {
      return const PlaceSearchScreen(
        widgetModelFactory: placeSearchScreenWidgetModelFactory,
      );
    },
  };

  static Widget Function(BuildContext) routeBuilder({
    required String? route,
    required Object? arguments,
  }) {
    final routeBuilderWithArgs = _mainNavigationRoutes[route];
    if (routeBuilderWithArgs != null) {
      return (_) => routeBuilderWithArgs(arguments);
    }

    return (_) => const SizedBox.shrink();
  }

  static void navigateTo(
    String route,
    GlobalKey<NavigatorState>? navigatorKey,
  ) {
    navigatorKey?.currentState?.pushReplacementNamed(route);
  }

  static Future<void> navigateToHomeScreen({
    required BuildContext context,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushReplacementNamed(
              HomeScreen.routeName,
            ) ??
        Future.value();
  }

  static Future<Object?> navigateToCategoriesScreen({
    required BuildContext context,
    required PlaceType? selectedPlaceType,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed<Object?>(
              SelectPlaceTypeScreen.routeName,
              arguments: selectedPlaceType,
            ) ??
        Future.value();
  }

  static Future<Object?> navigateToSelectingGeolocationScreen({
    required BuildContext context,
    required LocationPoint? selectedGeolocation,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed<Object?>(
              SelectGeolocationScreen.routeName,
              arguments: selectedGeolocation,
            ) ??
        Future.value();
  }

  static Future<void> navigateToAddNewPlaceScreen({
    required BuildContext context,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed(
              AddPlaceScreen.routeName,
            ) ??
        Future.value();
  }

  static Future<void> navigateToFiltersScreen({
    required BuildContext context,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed(
              FiltersScreen.routeName,
            ) ??
        Future.value();
  }

  static Future<void> navigateToPlaceDetailsScreen({
    required BuildContext context,
    required Place place,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed(
              PlaceDetailsScreen.routeName,
              arguments: place,
            ) ??
        Future.value();
  }

  static Future<void> navigateToSearchScreen({
    required BuildContext context,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed(
              PlaceSearchScreen.routeName,
            ) ??
        Future.value();
  }

  static Future<void> navigateToOnboardingScreen({
    required BuildContext context,
    bool fromLaunch = true,
  }) {
    return navigators[mainNavigatorKey]?.currentState?.pushNamed(
              OnboardingScreen.routeName,
              arguments: fromLaunch,
            ) ??
        Future.value();
  }
}
