// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_reader_app/features/discovery/domain/repositories/DiscoveryRepository.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';

class MockDiscoveryRepository extends Mock implements DiscoveryRepository {}

void main() {
  MockDiscoveryRepository mockDiscoveryRepository;
  GetNewsByKeyword useCase;

  setUp(() {
    mockDiscoveryRepository = MockDiscoveryRepository();
    useCase = GetNewsByKeyword(mockDiscoveryRepository);
  });

  final params = Params(keyword: "new iphone", page: 1, pageSize: 20);

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
    'should get news by keyword from the repository',
        () async {
      // arrange
      when(mockDiscoveryRepository.getNewsByKeyword(params.keyword, params.page, params.pageSize))
          .thenAnswer((_) async => Right(articles));
      // act
      final result = await useCase.call(params);

      // assert
      expect(result, Right(articles));
      verify(mockDiscoveryRepository.getNewsByKeyword(params.keyword, params.page, params.pageSize));
      verifyNoMoreInteractions(mockDiscoveryRepository);
    },
  );
}