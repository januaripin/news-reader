import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/repositories/home_repository.dart';

class GetTopHeadlines extends UseCase<List<Article>, String?> {
  final HomeRepository homeRepository;

  GetTopHeadlines(this.homeRepository);

  @override
  Future<Either<Failure, List<Article>>> call(String? params) async {
    return await homeRepository.getTopHeadlines(params);
  }
}