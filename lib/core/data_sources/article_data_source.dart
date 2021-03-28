import 'package:news_reader_app/features/home/data/models/article_model.dart';

abstract class ArticleDataSource {
  List<ArticleModel> getTopHeadlinesModels(json) {
    List<ArticleModel> articleModels = List.empty(growable: true);
    json.forEach((v) {
      articleModels.add(ArticleModel.fromJson(v));
    });
    return articleModels;
  }
}
