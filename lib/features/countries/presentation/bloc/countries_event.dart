import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCountriesEvent extends CountriesEvent {
  const GetAllCountriesEvent();
}

class RefreshCountriesEvent extends CountriesEvent {
  const RefreshCountriesEvent();
}

class SearchCountriesEvent extends CountriesEvent {
  final String query;

  const SearchCountriesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GetCountryByNameEvent extends CountriesEvent {
  final String countryName;

  const GetCountryByNameEvent({required this.countryName});

  @override
  List<Object?> get props => [countryName];
}

class ResetCountriesEvent extends CountriesEvent {
  const ResetCountriesEvent();
}
