part of 'top_headlines_bloc.dart';

abstract class TopHeadlinesEvent extends Equatable {
  const TopHeadlinesEvent();
}

class GetTopHeadlinesEvent extends TopHeadlinesEvent {
  final String sourceId;
  final int page;
  final int pageSize;

  GetTopHeadlinesEvent({required this.sourceId, required this.page, required this.pageSize});

  @override
  List<Object?> get props => [sourceId, page, pageSize];

}
