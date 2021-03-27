import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final articleModel = ArticleModel(
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
          "Prince William is the hottest bald guy on this planet -- so concludes a new study that ranked where he lands on Google searches ... but the internet doesn't seem to be buying it.\r\nA cosmetic surgery … [+1784 chars]");

  test(
    'should be a subclass of Article entity',
    () async {
      // assert
      expect(articleModel, isA<Article>());
    },
  );

  test(
    'should parse article JSON to article model',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('article.json'));

      // act
      final result = ArticleModel.fromJson(jsonMap);

      // assert
      expect(result, articleModel);
    },
  );
}
