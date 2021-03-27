import 'package:news_reader_app/features/home/data/models/source_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<SourceModel>> getSources();
}
