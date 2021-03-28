import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/discovery/domain/repositories/DiscoveryRepository.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';

class GetNewsByKeyword extends UseCase<List<Article>, Params> {
  final DiscoveryRepository discoveryRepository;

  GetNewsByKeyword(this.discoveryRepository);

  @override
  Future<Either<Failure, List<Article>>> call(Params params) async {
    return await discoveryRepository.getNewsByKeyword(params.keyword, params.page, params.pageSize);
  }
}

class Params extends Equatable {
  final String keyword;
  final int page;
  final int pageSize;

  Params({required this.keyword, required this.page, required this.pageSize});

  @override
  List<Object?> get props => [keyword, pageSize, page];
}