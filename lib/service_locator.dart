import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_reader_app/features/discovery/data/data_sources/discovery_remote_data_source.dart';
import 'package:news_reader_app/features/discovery/data/repositories/discovery_repository_impl.dart';
import 'package:news_reader_app/features/discovery/domain/repositories/DiscoveryRepository.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';
import 'package:news_reader_app/features/discovery/presentation/bloc/news_by_keyword_bloc.dart';
import 'package:news_reader_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:news_reader_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:news_reader_app/features/home/domain/repositories/home_repository.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_sources.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_top_headlines.dart';
import 'package:news_reader_app/features/home/presentation/bloc/source_bloc.dart';
import 'package:news_reader_app/features/home/presentation/bloc/top_headlines_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News Reader
  // Bloc
  sl.registerFactory(() => SourceBloc(sl()));
  sl.registerFactory(() => TopHeadlinesBloc(sl()));
  sl.registerFactory(() => NewsByKeywordBloc(sl()));

  // UseCase
  sl.registerLazySingleton(() => GetSources(sl()));
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => GetNewsByKeyword(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<DiscoveryRepository>(
      () => DiscoveryRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // DataSource
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<DiscoveryRemoteDataSource>(
      () => DiscoveryRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
