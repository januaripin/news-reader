// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/discovery/data/data_sources/discovery_remote_data_source.dart';
import 'package:news_reader_app/features/discovery/data/repositories/discovery_repository_impl.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';

import '../../../../core/network/mock_network_info.dart';

class MockDiscoveryRemoteDataSource extends Mock
    implements DiscoveryRemoteDataSource {}

void main() {
  MockNetworkInfo mockNetworkInfo;
  MockDiscoveryRemoteDataSource mockDiscoveryRemoteDataSource;
  DiscoveryRepositoryImpl repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockDiscoveryRemoteDataSource = MockDiscoveryRemoteDataSource();
    repository = DiscoveryRepositoryImpl(
      remoteDataSource: mockDiscoveryRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body, {bool isOnline}) {
    group('device is ${isOnline ? 'online' : 'offline'}', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isOnline);
      });

      body();
    });
  }

  group('getNewsByKeyword', () {
    final params = Params(keyword: "new iphone", page: 1, pageSize: 20);

    final articleModels = List.of([
      ArticleModel(
        source: SourceModel(id: "", name: "TMZ"),
        author: "TMZ Staff",
        title:
        "Prince William Dubbed World's Sexiest Bald Man, Internet Outraged - TMZ",
        description:
        "The Duke of Cambridge is hotter than Shemar Moore, so says a UK surgery practice.",
        url:
        "https://www.tmz.com/2021/03/27/prince-william-worlds-sexiest-bald-man-google-survey-study/",
        urlToImage:
        "https://imagez.tmz.com/image/e9/16by9/2021/03/27/e96ec187bf36449aaa9ecc7acfb247cc_xl.jpg",
        publishedAt: "2021-03-27T18:20:04Z",
        content:
        "Prince William is the hottest bald guy on this planet -- so concludes a new study that ranked where he lands on Google searches ... but the internet doesn't seem to be buying it.\r\nA cosmetic surgery … [+1784 chars]",
      )
    ]);

    test(
      'should check if the device is online',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getNewsByKeyword(
            params.keyword, params.page, params.pageSize);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is success',
            () async {
          // arrange
          when(mockDiscoveryRemoteDataSource.getNewsByKeyword(
              params.keyword, params.page, params.pageSize))
              .thenAnswer((_) async => articleModels);

          // act
          final result = await repository.getNewsByKeyword(
              params.keyword, params.page, params.pageSize);

          // assert
          verify(mockDiscoveryRemoteDataSource.getNewsByKeyword(
              params.keyword, params.page, params.pageSize));
          expect(result, equals(Right(articleModels)));
        },
      );
    }, isOnline: true);

    runTestOnline(() {
      test(
        'should return no internet failure',
            () async {
          // arrange
          when(mockDiscoveryRemoteDataSource.getNewsByKeyword(
              params.keyword, params.page, params.pageSize))
              .thenAnswer((_) async => articleModels);

          // act
          final result = await repository.getNewsByKeyword(
              params.keyword, params.page, params.pageSize);

          // assert
          verifyNever(mockDiscoveryRemoteDataSource.getNewsByKeyword(
              params.keyword, params.page, params.pageSize));
          verifyZeroInteractions(mockDiscoveryRemoteDataSource);
          expect(result, equals(Left(NoInternetFailure())));
        },
      );
    }, isOnline: false);
  });
}
