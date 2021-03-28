import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/exceptions.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/network/network_info.dart';
import 'package:news_reader_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Source>>> getSources() async {
    if (!(await networkInfo.isConnected)) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await remoteDataSource.getSources());
    } on HttpException {
      return Left(HttpFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines(
      String sourceId, int page, int pageSize) async {
    if (!(await networkInfo.isConnected)) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await remoteDataSource.getTopHeadlines(sourceId, page, pageSize));
    } on HttpException {
      return Left(HttpFailure());
    }
  }
}
