import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        emit(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        emit(ThemeMode.light);
        break;
      case ThemeMode.system:
        emit(ThemeMode.dark);
        break;
    }
  }

  void setLightTheme() => emit(ThemeMode.light);
  void setDarkTheme() => emit(ThemeMode.dark);
  void setSystemTheme() => emit(ThemeMode.system);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      final String themeModeString = json['themeMode'] as String;
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == themeModeString,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.name};
  }
}
