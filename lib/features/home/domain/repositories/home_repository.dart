import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Source>>> getSources();

  Future<Either<Failure, List<Article>>> getTopHeadlines(String sourceId, int page, int pageSize);
}
