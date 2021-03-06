import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/screen/app/app.dart';
import 'package:places/ui/screen/app/app_screen_model.dart';
import 'package:places/ui/screen/app/di/app_scope.dart';
import 'package:provider/provider.dart';

/// Фабрика для [AppWidgetModel]
AppWidgetModel appWidgetModelFactory(BuildContext context) {
  final dependencies = context.read<IAppScope>();
  final model = AppScreenModel(
    errorHandler: dependencies.errorHandler,
    settingsManager: dependencies.settingsManager,
  );

  return AppWidgetModel(model);
}

/// Виджет-модель для [AppScreenModel]
class AppWidgetModel extends WidgetModel<App, AppScreenModel>
    implements IAppWidgetModel {
  @override
  ListenableState<ThemeMode> get currentThemeModeState =>
      model.currentThemeModeState;

  AppWidgetModel(AppScreenModel model) : super(model);
}

abstract class IAppWidgetModel extends IWidgetModel {
  /// Состояние текущей темы приложения
  ListenableState<ThemeMode> get currentThemeModeState;
}
