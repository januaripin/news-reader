// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_top_headlines.dart';

import '../repositories/mock_home_repository.dart';

void main() {
  GetTopHeadlines useCase;
  MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetTopHeadlines(mockHomeRepository);
  });

  final params = Params(sourceId: "all", page: 1, pageSize: 20);

  final article = Article(
    Source(
      "ny-times",
      "New Yort Times",
    ),
    "author",
    "title",
    "description",
    "url",
    "urlToImage",
    "publishedAt",
    "content",
  );

  final articles = List<Article>.of([article], growable: true);

  test(
    'should get top headlines from the repository',
    () async {
      // arrange
      when(mockHomeRepository.getTopHeadlines(params.sourceId, params.page, params.pageSize))
          .thenAnswer((_) async => Right(articles));
      // act
      final result = await useCase.call(params);

      // assert
      expect(result, Right(articles));
      verify(mockHomeRepository.getTopHeadlines(params.sourceId, params.page, params.pageSize));
      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
