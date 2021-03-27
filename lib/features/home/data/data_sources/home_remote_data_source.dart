import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_reader_app/core/constants/config.dart';
import 'package:news_reader_app/core/errors/exceptions.dart';
import 'package:news_reader_app/features/home/data/models/source_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<SourceModel>> getSources();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SourceModel>> getSources() async {
    final response = await client.get(
      Uri.parse(
        '${Config.API_URL}/${Config.API_VERSION}/sources?apiKey=${Config.API_KEY}&country=us',
      ),
    );

    if (response.statusCode == 200) {
      return getSourceModels(json.decode(response.body)['sources']);
    } else {
      throw HttpException(code: response.statusCode, message: response.body);
    }
  }

  List<SourceModel> getSourceModels(json) {
    List<SourceModel> sourceModels = List.empty(growable: true);
    json.forEach((v) {
      sourceModels.add(SourceModel.fromJson(v));
    });
    return sourceModels;
  }
}
