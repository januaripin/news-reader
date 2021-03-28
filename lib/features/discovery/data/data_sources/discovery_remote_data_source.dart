import 'package:dartz/dartz.dart';
import 'package:news_reader_app/features/home/data/models/article_model.dart';

abstract class DiscoveryRemoteDataSource {
  Future<List<ArticleModel>> getNewsByKeyword(String keyword, int page,
      int pageSize);
}