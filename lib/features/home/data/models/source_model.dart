import 'package:news_reader_app/features/home/domain/entities/source.dart';

class SourceModel extends Source {
  SourceModel({required String id, required String name}) : super(id, name);

  factory SourceModel.fromJson(Map<String, dynamic> jsonMap) {
    return SourceModel(id: jsonMap['id'] ?? '', name: jsonMap['name']);
  }
}