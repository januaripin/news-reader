// @dart=2.9

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/constants/config.dart';
import 'package:news_reader_app/features/discovery/data/data_sources/discovery_remote_data_source.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../home/data/data_sources/home_remote_data_source_test.dart';

void main() {
  MockHttpClient mockHttpClient;
  DiscoveryRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = DiscoveryRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getNewsByKeyword', () {
    final params = Params(keyword: "new iphone", page: 1, pageSize: 20);
    test(
      'should perform a GET request on a URL',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            fixture('articles.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // act
        final result = await remoteDataSource.getNewsByKeyword(
            params.keyword, params.page, params.pageSize);

        // assert
        expect(
            result,
            remoteDataSource.getTopHeadlinesModels(
                json.decode(fixture('articles.json'))['articles']));

        verify(
          mockHttpClient.get(
            Uri.parse(
              '${Config.API_URL}/${Config.API_VERSION}/everything?apiKey=${Config.API_KEY}&q=${params.keyword}&qInTitle=${params.keyword}&page=${params.page}&pageSize=${params.pageSize}',
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
        expect(remoteDataSource.getNewsByKeyword(
            params.keyword, params.page, params.pageSize), throwsException);
      },
    );
  });
}
