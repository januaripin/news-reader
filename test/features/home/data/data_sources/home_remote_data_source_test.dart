// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/constants/config.dart';
import 'package:news_reader_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_top_headlines.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  HomeRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = HomeRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getSources', () {
    test(
      'should perform a GET request on a URL',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            fixture('sources.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // act
        final result = await remoteDataSource.getSources();

        // assert
        expect(
            result,
            remoteDataSource.getSourceModels(
                json.decode(fixture('sources.json'))['sources']));
        verify(
          mockHttpClient.get(
            Uri.parse(
              '${Config.API_URL}/${Config.API_VERSION}/sources?apiKey=${Config.API_KEY}&country=us',
            ),
          ),
        );
      },
    );

    test(
      'should throw a HttpException',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            fixture('api_key_missing.json'),
            401,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // assert
        expect(remoteDataSource.getSources(), throwsException);
      },
    );
  });

  group('getTopHeadlines', () {
    final fromAllSourceParams = Params(sourceId: "all", page: 1, pageSize: 20);
    test(
      'should throw a HttpException',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            fixture('api_key_missing.json'),
            401,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // assert
        expect(remoteDataSource.getTopHeadlines(fromAllSourceParams.sourceId, fromAllSourceParams.page, fromAllSourceParams.pageSize), throwsException);
      },
    );

    group('fromAllSource', () {
      test(
        'should perform a GET request on a URL',
        () async {
          // arrange
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(
              fixture('articles.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          // act
          final result = await remoteDataSource.getTopHeadlines(fromAllSourceParams.sourceId, fromAllSourceParams.page, fromAllSourceParams.pageSize);

          // assert
          expect(
              result,
              remoteDataSource.getTopHeadlinesModels(
                  json.decode(fixture('articles.json'))['articles']));
          verify(
            mockHttpClient.get(
              Uri.parse(
                '${Config.API_URL}/${Config.API_VERSION}/top-headlines?apiKey=${Config.API_KEY}&page=${fromAllSourceParams.page}&pageSize=${fromAllSourceParams.pageSize}&country=us',
              ),
            ),
          );
        },
      );
    });

    group('from One Source', () {
      final params = Params(sourceId: "cnn", page: 1, pageSize: 20);

      test(
        'should perform a GET request on a URL',
        () async {
          // arrange
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(
              fixture('cnn_articles.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          // act
          final result = await remoteDataSource.getTopHeadlines(params.sourceId, params.page, params.pageSize);

          // assert
          expect(
              result,
              remoteDataSource.getTopHeadlinesModels(
                  json.decode(fixture('cnn_articles.json'))['articles']));
          verify(
            mockHttpClient.get(
              Uri.parse(
                '${Config.API_URL}/${Config.API_VERSION}/top-headlines?apiKey=${Config.API_KEY}&page=${params.page}&pageSize=${params.pageSize}&sources=${params.sourceId}',
              ),
            ),
          );
        },
      );
    });
  });
}
