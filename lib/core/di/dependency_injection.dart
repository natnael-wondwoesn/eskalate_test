import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/countries/data/datasource/countries_remote_datasource.dart';
import '../../features/countries/data/datasource/countries_remote_datasource_impl.dart';
import '../../features/countries/data/datasource/countries_local_datasource.dart';
import '../../features/countries/data/datasource/countries_local_datasource_impl.dart';
import '../../features/countries/data/repo/countries_repository_impl.dart';
import '../../features/countries/domain/repository/countries_repository.dart';
import '../../features/countries/domain/usecase/get_all_countries_usecase.dart';
import '../../features/countries/domain/usecase/get_country_by_name_usecase.dart';
import '../../features/countries/presentation/bloc/countries_bloc.dart';
import '../theme/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();

    // Configure Dio
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => getIt<Logger>().d(object.toString()),
      ),
    );

    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    return dio;
  });

  getIt.registerLazySingleton<Logger>(() => Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.none,
        ),
      ));

  // Data sources
  getIt.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<CountriesLocalDataSource>(
    () => CountriesLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
      logger: getIt<Logger>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      remoteDataSource: getIt<CountriesRemoteDataSource>(),
      localDataSource: getIt<CountriesLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetAllCountriesUseCase>(
    () => GetAllCountriesUseCase(
      repository: getIt<CountriesRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetCountryByNameUseCase>(
    () => GetCountryByNameUseCase(
      repository: getIt<CountriesRepository>(),
    ),
  );

  // BLoC
  getIt.registerFactory<CountriesBloc>(
    () => CountriesBloc(
      getAllCountriesUseCase: getIt<GetAllCountriesUseCase>(),
      getCountryByNameUseCase: getIt<GetCountryByNameUseCase>(),
    ),
  );

  // Theme management
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
