import 'package:dartz/dartz.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/domain/repositories/home_repository.dart';

class GetSources extends UseCase<List<Source>, NoParams> {
  final HomeRepository homeRepository;

  GetSources(this.homeRepository);

  Future<Either<Failure, List<Source>>> call(NoParams params) async {
    return await homeRepository.getSources();
  }
}
