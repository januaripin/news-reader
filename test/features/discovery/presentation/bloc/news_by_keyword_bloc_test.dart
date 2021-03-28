// @dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';
import 'package:news_reader_app/features/discovery/presentation/bloc/news_by_keyword_bloc.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetNewsByKeyword extends Mock implements GetNewsByKeyword {}

void main() {
  MockGetNewsByKeyword mockGetNewsByKeyword;

  setUp(() {
    mockGetNewsByKeyword = MockGetNewsByKeyword();
  });

  final articles =
      List.of([ArticleModel.fromJson(json.decode(fixture('article.json')))]);
  final params = Params(keyword: "new iphone", page: 1, pageSize: 20);

  blocTest(
    'emits [] when nothing is added',
    build: () => NewsByKeywordBloc(mockGetNewsByKeyword),
    expect: () => [],
  );

  blocTest(
    'emits [GetNewsByKeywordLoading,GetNewsByKeywordSuccess] when nothing is added',
    build: () {
      when(mockGetNewsByKeyword(params))
          .thenAnswer((_) async => Right(articles));
      return NewsByKeywordBloc(mockGetNewsByKeyword);
    },
    act: (bloc) => bloc.add(GetNewsByKeywordEvent(
        keyword: params.keyword, page: params.page, pageSize: params.pageSize)),
    expect: () => [
      GetNewsByKeywordLoading(),
      GetNewsByKeywordSuccess(articles: articles)
    ],
  );

  blocTest(
    'emits [GetNewsByKeywordLoading,GetNewsByKeywordError] when nothing is added',
    build: () {
      when(mockGetNewsByKeyword(params))
          .thenAnswer((_) async => Left(NoInternetFailure()));
      return NewsByKeywordBloc(mockGetNewsByKeyword);
    },
    act: (bloc) => bloc.add(GetNewsByKeywordEvent(
        keyword: params.keyword, page: params.page, pageSize: params.pageSize)),
    expect: () => [
      GetNewsByKeywordLoading(),
      GetNewsByKeywordError(message: 'Silakan periksa koneksi internet Anda')
    ],
  );
}
