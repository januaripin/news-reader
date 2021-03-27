// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:news_reader_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:news_reader_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_sources.dart';
import 'package:news_reader_app/features/home/presentation/bloc/source_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News Reader
  // Bloc
  sl.registerFactory(() => SourceBloc(sl()));

  // UseCase
  sl.registerLazySingleton(() => GetSources(sl()));

  // Repository
  sl.registerLazySingleton(() => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // DataSource
  sl.registerLazySingleton(() => HomeRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}