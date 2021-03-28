import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_reader_app/core/constants/config.dart';
import 'package:news_reader_app/core/data_sources/article_data_source.dart';
import 'package:news_reader_app/core/errors/exceptions.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';

abstract class DiscoveryRemoteDataSource {
  Future<List<ArticleModel>> getNewsByKeyword(
      String keyword, int page, int pageSize);
}

class DiscoveryRemoteDataSourceImpl extends ArticleDataSource
    implements DiscoveryRemoteDataSource {
  final http.Client client;

  DiscoveryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> getNewsByKeyword(
      String keyword, int page, int pageSize) async {
    String params =
        'apiKey=${Config.API_KEY}&q=$keyword&qInTitle=$keyword&page=$page&pageSize=$pageSize';

    final response = await client.get(
      Uri.parse(
        '${Config.API_URL}/${Config.API_VERSION}/everything?$params',
      ),
    );

    if (response.statusCode == 200) {
      return getTopHeadlinesModels(json.decode(response.body)['articles']);
    } else {
      throw HttpException(code: response.statusCode, message: response.body);
    }
  }
}
