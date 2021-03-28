import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final sourceModel = SourceModel(id: "abc-news", name: "ABC News");

  test(
    'should be a subclass of Source entity',
    () async {
      // assert
      expect(sourceModel, isA<Source>());
    },
  );

  test(
    'should parse source JSON to source model',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('source.json'));

      // act
      final result = SourceModel.fromJson(jsonMap);

      // assert
      expect(result, sourceModel);
    },
  );
}
