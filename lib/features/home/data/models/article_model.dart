import 'package:news_reader_app/features/home/data/models/source_model.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';

class ArticleModel extends Article {
  ArticleModel({
    required Source source,
    required String author,
    required String title,
    required String description,
    required String url,
    required String urlToImage,
    required String publishedAt,
    required String content,
  }) : super(
          source,
          author,
          title,
          description,
          url,
          urlToImage,
          publishedAt,
          content,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> jsonMap) {
    return ArticleModel(
      source: SourceModel.fromJson(jsonMap['source']),
      author: jsonMap['author'] ?? "",
      title: jsonMap['title'] ?? "",
      description: jsonMap['description'] ?? "",
      url: jsonMap['url'] ?? "",
      urlToImage: jsonMap['urlToImage'] ?? "",
      publishedAt: jsonMap['publishedAt'] ?? "",
      content: jsonMap['content'] ?? "",
    );
  }
}
