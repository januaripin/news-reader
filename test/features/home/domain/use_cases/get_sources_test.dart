// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_sources.dart';

import '../repositories/mock_home_repository.dart';

void main() {
  GetSources useCase;
  MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetSources(mockHomeRepository);
  });

  final source = Source("ny-times", "New York Times");
  final List<Source> sources = List<Source>.of([source], growable: true);

  test(
    'should get sources from the repository',
    () async {
      // arrange
      when(mockHomeRepository.getSources())
          .thenAnswer((_) async => Right(sources));
      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, Right(sources));
      verify(mockHomeRepository.getSources());
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
