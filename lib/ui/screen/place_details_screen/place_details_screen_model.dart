import 'package:elementary/elementary.dart';
import 'package:places/domain/interactor/place_interactor.dart';
import 'package:places/domain/model/place.dart';
import 'package:places/ui/screen/place_details_screen/place_details_screen.dart';

/// Модель для [PlaceDetailsScreen]
class PlaceDetailsScreenModel extends ElementaryModel {
  final PlaceInteractor _placeInteractor;

  PlaceDetailsScreenModel({
    required PlaceInteractor placeInteractor,
    required ErrorHandler errorHandler,
  })  : _placeInteractor = placeInteractor,
        super(errorHandler: errorHandler);

  /// Получение деталей по месту [place]
  Future<Place> getPlaceDetails(Place place) =>
      _placeInteractor.getPlaceDetails(place: place);

  /// Добавление места [place] в список посещенных мест
  Future<void> addPlaceInVisited({required Place place}) async =>
      _placeInteractor.addPlaceInVisited(place);

  /// Метод добавления/удаления места в/из избранно-е/го
  Future<void> changeFavorite(Place place) =>
      _placeInteractor.changeFavorite(place);

  /// Планирование даты посещения [planDate] места [place]
  Future<void> setPlacePlanDate({
    required Place place,
    required DateTime planDate,
  }) async {
    await _placeInteractor.setPlanDate(
      place: place,
      planDate: planDate,
    );
  }
}
