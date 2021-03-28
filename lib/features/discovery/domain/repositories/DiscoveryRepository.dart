import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';

abstract class DiscoveryRepository {
  Future<Either<Failure, List<Article>>> getNewsByKeyword(
      String keyword, int page, int pageSize);
}
