import 'package:equatable/equatable.dart';

import '../../domain/entity/countries_entity.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object?> get props => [];
}

class CountriesInitial extends CountriesState {
  const CountriesInitial();
}

class CountriesLoading extends CountriesState {
  const CountriesLoading();
}

class CountriesAllLoaded extends CountriesState {
  final List<CountriesEntity> countries;

  const CountriesAllLoaded({required this.countries});

  @override
  List<Object?> get props => [countries];
}

class CountriesSingleLoaded extends CountriesState {
  final CountriesEntity country;

  const CountriesSingleLoaded({required this.country});

  @override
  List<Object?> get props => [country];
}

class CountriesNotFound extends CountriesState {
  final String message;

  const CountriesNotFound({required this.message});

  @override
  List<Object?> get props => [message];
}

class CountriesError extends CountriesState {
  final String message;

  const CountriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
