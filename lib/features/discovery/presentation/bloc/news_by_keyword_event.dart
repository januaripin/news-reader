part of 'news_by_keyword_bloc.dart';

abstract class NewsByKeywordEvent extends Equatable {
  const NewsByKeywordEvent();
}

class GetNewsByKeywordEvent extends NewsByKeywordEvent {
  final String keyword;
  final int page;
  final int pageSize;

  GetNewsByKeywordEvent(
      {required this.keyword, required this.page, required this.pageSize});

  @override
  List<Object?> get props => [keyword, page, pageSize];

}
