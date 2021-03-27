// @dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader_app/core/errors/failures.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_sources.dart';
import 'package:news_reader_app/features/home/presentation/bloc/source_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetSources extends Mock implements GetSources {}

void main() {
  MockGetSources mockGetSources;

  setUp(() {
    mockGetSources = MockGetSources();
  });
  final sources =
      List.of([SourceModel.fromJson(json.decode(fixture('source.json')))]);

  blocTest(
    'emits [] when nothing is added',
    build: () => SourceBloc(mockGetSources),
    expect: () => [],
  );

  blocTest(
    'emits [GetSourceListLoading,GetSourceListSuccess] when nothing is added',
    build: () {
      when(mockGetSources(NoParams())).thenAnswer((_) async => Right(sources));
      return SourceBloc(mockGetSources);
    },
    act: (bloc) => bloc.add(GetSourceListEvent()),
    expect: () =>
        [GetSourceListLoading(), GetSourceListSuccess(sources: sources)],
  );

  blocTest(
    'emits [GetSourceListLoading,GetSourceListError] when nothing is added',
    build: () {
      when(mockGetSources(NoParams())).thenAnswer((_) async => Left(NoInternetFailure()));
      return SourceBloc(mockGetSources);
    },
    act: (bloc) => bloc.add(GetSourceListEvent()),
    expect: () =>
        [GetSourceListLoading(), GetSourceListError(message: 'Silakan periksa koneksi internet Anda')],
  );


}
