import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/exceptions.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/network/network_info.dart';
import 'package:news_reader_app/features/discovery/data/data_sources/discovery_remote_data_source.dart';
import 'package:news_reader_app/features/discovery/domain/repositories/DiscoveryRepository.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';

class DiscoveryRepositoryImpl extends DiscoveryRepository {
  final DiscoveryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DiscoveryRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Article>>> getNewsByKeyword(
      String keyword, int page, int pageSize) async {

    if (!(await networkInfo.isConnected)) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await remoteDataSource.getNewsByKeyword(keyword, page, pageSize));
    } on HttpException {
      return Left(HttpFailure());
    }
  }
}
