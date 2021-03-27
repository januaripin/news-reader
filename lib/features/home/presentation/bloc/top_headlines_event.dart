part of 'top_headlines_bloc.dart';

abstract class TopHeadlinesEvent extends Equatable {
  const TopHeadlinesEvent();
}

class GetTopHeadlinesEvent extends TopHeadlinesEvent {
  final String sourceId;

  GetTopHeadlinesEvent(this.sourceId);

  @override
  List<Object?> get props => [sourceId];

}
