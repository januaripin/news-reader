// @dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/constants/config.dart';
import 'package:news_reader_app/features/home/data/data_sources/home_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  HomeRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = HomeRemoteDataSourceImpl(client: mockHttpClient);
  });

  test(
    'should perform a GET request on a URL',
    () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(fixture('sources.json'), 200),
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
        (_) async => http.Response(fixture('api_key_missing.json'), 401),
      );

      // assert
      expect(remoteDataSource.getSources(), throwsException);
    },
  );
}
