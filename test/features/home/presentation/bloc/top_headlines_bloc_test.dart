// @dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_top_headlines.dart';
import 'package:news_reader_app/features/home/presentation/bloc/top_headlines_bloc.dart';

class MockGetTopHeadlines extends Mock implements GetTopHeadlines {}

void main() {
  MockGetTopHeadlines mockGetTopHeadlines;

  setUp(() {
    mockGetTopHeadlines = MockGetTopHeadlines();
  });

  final params = Params(sourceId: "all", page: 1);

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

  blocTest(
    'emits [] when nothing is added',
    build: () => TopHeadlinesBloc(mockGetTopHeadlines),
    expect: () => [],
  );

  blocTest(
    'emits [GetTopHeadlinesLoading,GetTopHeadlinesSuccess] when nothing is added',
    build: () {
      when(mockGetTopHeadlines(params))
          .thenAnswer((_) async => Right(articleModels));
      return TopHeadlinesBloc(mockGetTopHeadlines);
    },
    act: (bloc) => bloc.add(GetTopHeadlinesEvent(sourceId: params.sourceId, page: params.page)),
    expect: () => [
      GetTopHeadlinesLoading(),
      GetTopHeadlinesSuccess(topHeadlines: articleModels)
    ],
  );

  blocTest(
    'emits [GetTopHeadlinesLoading,GetTopHeadlinesError] when nothing is added',
    build: () {
      when(mockGetTopHeadlines(params))
          .thenAnswer((_) async => Left(NoInternetFailure()));
      return TopHeadlinesBloc(mockGetTopHeadlines);
    },
    act: (bloc) => bloc.add(GetTopHeadlinesEvent(sourceId: params.sourceId, page: params.page)),
    expect: () => [
      GetTopHeadlinesLoading(),
      GetTopHeadlinesError(message: 'Silakan periksa koneksi internet Anda')
    ],
  );
}
