// @dart=2.9
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/data/repositories/home_repository_impl.dart';

import '../../../../core/network/mock_network_info.dart';
import '../data_sources/mock_home_remote_data_source.dart';

void main() {
  HomeRepositoryImpl repository;
  MockHomeRemoteDataSource mockHomeRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockHomeRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(
        remoteDataSource: mockHomeRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body, {bool isOnline}) {
    group('device is ${isOnline ? 'online' : 'offline'}', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isOnline);
      });

      body();
    });
  }

  group('getSources', () {
    final sourceModels =
        List.of([SourceModel(id: "abc-news", name: "ABC News")]);
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getSources();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is success',
        () async {
          // arrange
          when(mockHomeRemoteDataSource.getSources())
              .thenAnswer((_) async => sourceModels);

          // act
          final result = await repository.getSources();

          // assert
          verify(mockHomeRemoteDataSource.getSources());
          expect(result, equals(Right(sourceModels)));
        },
      );
    }, isOnline: true);

    runTestOnline(() {
      test(
        'should return no internet failure',
        () async {
          // arrange
          when(mockHomeRemoteDataSource.getSources())
              .thenAnswer((_) async => sourceModels);

          // act
          final result = await repository.getSources();

          // assert
          verifyNever(mockHomeRemoteDataSource.getSources());
          verifyZeroInteractions(mockHomeRemoteDataSource);
          expect(result, equals(Left(NoInternetFailure())));
        },
      );
    }, isOnline: false);
  });

  group('getTopHeadlines', () {
    final sourceId = "all";

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
        repository.getTopHeadlines(sourceId);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is success',
        () async {
          // arrange
          when(mockHomeRemoteDataSource.getTopHeadlines(sourceId))
              .thenAnswer((_) async => articleModels);

          // act
          final result = await repository.getTopHeadlines(sourceId);

          // assert
          verify(mockHomeRemoteDataSource.getTopHeadlines(sourceId));
          expect(result, equals(Right(articleModels)));
        },
      );
    }, isOnline: true);

    runTestOnline(() {
      test(
        'should return no internet failure',
        () async {
          // arrange
          when(mockHomeRemoteDataSource.getTopHeadlines(sourceId))
              .thenAnswer((_) async => articleModels);

          // act
          final result = await repository.getTopHeadlines(sourceId);

          // assert
          verifyNever(mockHomeRemoteDataSource.getTopHeadlines(sourceId));
          verifyZeroInteractions(mockHomeRemoteDataSource);
          expect(result, equals(Left(NoInternetFailure())));
        },
      );
    }, isOnline: false);
  });
}
