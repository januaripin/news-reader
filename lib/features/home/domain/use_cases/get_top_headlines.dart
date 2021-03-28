import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/repositories/home_repository.dart';

class GetTopHeadlines extends UseCase<List<Article>, Params> {
  final HomeRepository homeRepository;

  GetTopHeadlines(this.homeRepository);

  @override
  Future<Either<Failure, List<Article>>> call(Params params) async {
    return await homeRepository.getTopHeadlines(params.sourceId, params.page, params.pageSize);
  }
}

class Params extends Equatable {
  final String sourceId;
  final int page;
  final int pageSize;

  Params({required this.sourceId, required this.page, required this.pageSize});

  @override
  List<Object?> get props => [sourceId, page, pageSize];

}