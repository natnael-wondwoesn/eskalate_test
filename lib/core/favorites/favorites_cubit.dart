import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final List<String> favoriteCountries;

  const FavoritesState({required this.favoriteCountries});

  @override
  List<Object> get props => [favoriteCountries];

  FavoritesState copyWith({List<String>? favoriteCountries}) {
    return FavoritesState(
      favoriteCountries: favoriteCountries ?? this.favoriteCountries,
    );
  }
}

class FavoritesCubit extends HydratedCubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState(favoriteCountries: []));

  void toggleFavorite(String countryName) {
    final currentFavorites = List<String>.from(state.favoriteCountries);

    if (currentFavorites.contains(countryName)) {
      currentFavorites.remove(countryName);
    } else {
      currentFavorites.add(countryName);
    }

    emit(state.copyWith(favoriteCountries: currentFavorites));
  }

  bool isFavorite(String countryName) {
    return state.favoriteCountries.contains(countryName);
  }

  void clearFavorites() {
    emit(const FavoritesState(favoriteCountries: []));
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    try {
      final favoritesList = json['favoriteCountries'] as List<dynamic>?;
      return FavoritesState(
        favoriteCountries: favoritesList?.cast<String>() ?? [],
      );
    } catch (e) {
      return const FavoritesState(favoriteCountries: []);
    }
  }

  @override
  Map<String, dynamic>? toJson(FavoritesState state) {
    return {
      'favoriteCountries': state.favoriteCountries,
    };
  }
}
