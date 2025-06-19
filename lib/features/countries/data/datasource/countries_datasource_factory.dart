import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'countries_remote_datasource.dart';
import 'countries_remote_datasource_impl.dart';

class CountriesDataSourceFactory {
  static CountriesRemoteDataSource createRemoteDataSource() {
    final dio = Dio();

    // Configure Dio with interceptors for logging and error handling
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => Logger().d(object.toString()),
      ),
    );

    // Set timeout configurations
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none,
      ),
    );

    return CountriesRemoteDataSourceImpl(
      dio: dio,
      logger: logger,
    );
  }
}
